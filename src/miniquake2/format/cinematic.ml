/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Header and Huffman-table reader for Quake II .cin streams. */
package miniquake2.format.cinematic

import miniquake2.format.types as ft
import miniquake2.format.binary as fbio

const HUFFMAN_COUNT_BYTES = 256 * 256
const HEADER_BYTES = 20 + HUFFMAN_COUNT_BYTES

// Parse header.
function parseHeader(data)
  if len(data) < HEADER_BYTES then return error(2700, "CIN header or Huffman table is truncated") end if
  width = fbio.i32(data, 0)
  height = fbio.i32(data, 4)
  sampleRate = fbio.i32(data, 8)
  sampleWidth = fbio.i32(data, 12)
  sampleChannels = fbio.i32(data, 16)
  if width <= 0 or height <= 0 or width > 4096 or height > 4096 then return error(2701, "invalid CIN dimensions") end if
  if sampleRate <= 0 or sampleRate > 192000 or (sampleWidth != 1 and sampleWidth != 2) or (sampleChannels != 1 and sampleChannels != 2) then
    return error(2702, "invalid CIN audio format")
  end if
  return ft.CinematicHeader(width, height, sampleRate, sampleWidth, sampleChannels, slice(data, 20, HUFFMAN_COUNT_BYTES), HEADER_BYTES)
end function

// Return the smallest node value.
function smallestNode(counts, used, count)
  bestCount = 0x7fffffff
  bestNode = -1
  i = 0
  while i < count
    if used[i] == false and counts[i] > 0 and counts[i] < bestCount then
      bestCount = counts[i]
      bestNode = i
    end if
    i = i + 1
  end while
  if bestNode >= 0 then used[bestNode] = true end if
  return bestNode
end function

// Build tree.
function buildTree(countRow)
  if len(countRow) != 256 then return error(2703, "CIN Huffman row must contain 256 counts") end if
  counts = array(511, 0)
  used = array(511, false)
  left = array(511, -1)
  right = array(511, -1)
  i = 0
  while i < 256
    counts[i] = countRow[i]
    i = i + 1
  end while
  nodeNumber = 256
  while nodeNumber < 511
    first = smallestNode(counts, used, nodeNumber)
    if first < 0 then break end if
    second = smallestNode(counts, used, nodeNumber)
    if second < 0 then break end if
    left[nodeNumber] = first
    right[nodeNumber] = second
    counts[nodeNumber] = counts[first] + counts[second]
    nodeNumber = nodeNumber + 1
  end while
  root = nodeNumber - 1
  // The original Huff1TableInit stores root 255 when a context row contains
  // fewer than two populated symbols. Retail CIN files contain many unused
  // zero rows, so rejecting them makes every stock cinematic unreadable.
  // Keeping the leaf root reproduces the classic decoder's bounded fallback.
  if root < 0 or root >= 511 then return error(2704, "CIN Huffman root is invalid") end if
  return ft.HuffmanTree(root, left, right)
end function

// Build tables.
function buildTables(header)
  if len(header.huffmanCounts) != HUFFMAN_COUNT_BYTES then return error(2705, "CIN Huffman table size mismatch") end if
  tables = array(256)
  previous = 0
  while previous < 256
    tables[previous] = buildTree(slice(header.huffmanCounts, previous * 256, 256))
    previous = previous + 1
  end while
  return tables
end function

// Decompress state.
function decompress(compressed, tables, maximumOutput)
  if len(compressed) < 5 then return error(2706, "compressed CIN frame is truncated") end if
  outputCount = fbio.i32(compressed, 0)
  if outputCount < 0 or outputCount > maximumOutput then return error(2707, "CIN decompressed size outside limit") end if
  if len(tables) != 256 then return error(2708, "CIN Huffman tables are incomplete") end if
  output = bytes(outputCount)
  tree = tables[0]
  nodeNumber = tree.root
  input = 4
  bitNumber = 0
  written = 0
  while written < outputCount
    if nodeNumber < 256 then
      output[written] = nodeNumber
      written = written + 1
      if written >= outputCount then break end if
      tree = tables[nodeNumber]
      nodeNumber = tree.root
    else
      if input >= len(compressed) then return error(2709, "CIN Huffman bitstream is truncated") end if
      bit = (compressed[input] >> bitNumber) & 1
      if bit == 0 then nodeNumber = tree.left[nodeNumber] else nodeNumber = tree.right[nodeNumber] end if
      if nodeNumber < 0 then return error(2710, "CIN Huffman node is invalid") end if
      bitNumber = bitNumber + 1
      if bitNumber == 8 then bitNumber = 0; input = input + 1 end if
    end if
  end while
  return output
end function

// Read frame.
function readFrame(data, offset, frameNumber, header, tables)
  if offset < header.frameDataOffset or offset + 4 > len(data) then return error(2711, "CIN frame command is truncated") end if
  command = fbio.i32(data, offset)
  offset = offset + 4
  if command == 2 then return ft.CinematicFrame(2, bytes(0), bytes(0), bytes(0), offset) end if
  if command != 0 and command != 1 then return error(2712, "invalid CIN frame command") end if
  palette = bytes(0)
  if command == 1 then
    if offset + 768 > len(data) then return error(2713, "CIN palette is truncated") end if
    palette = slice(data, offset, 768)
    offset = offset + 768
  end if
  if offset + 4 > len(data) then return error(2714, "CIN compressed size is truncated") end if
  compressedSize = fbio.i32(data, offset)
  offset = offset + 4
  if compressedSize < 1 or compressedSize > 0x20000 or offset + compressedSize > len(data) then return error(2715, "invalid CIN compressed frame size") end if
  pixels = decompress(slice(data, offset, compressedSize), tables, header.width * header.height)
  offset = offset + compressedSize
  firstNumerator = frameNumber * header.sampleRate
  lastNumerator = (frameNumber + 1) * header.sampleRate
  firstSample = (firstNumerator - (firstNumerator % 14)) / 14
  lastSample = (lastNumerator - (lastNumerator % 14)) / 14
  sampleCount = lastSample - firstSample
  audioBytes = sampleCount * header.sampleWidth * header.sampleChannels
  if audioBytes < 0 or offset + audioBytes > len(data) then return error(2716, "CIN audio block is truncated") end if
  audio = slice(data, offset, audioBytes)
  return ft.CinematicFrame(command, palette, pixels, audio, offset + audioBytes)
end function
