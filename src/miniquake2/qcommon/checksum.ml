//! Provides miniquake2 qcommon checksum facilities for this project.

/*
Copyright (C) 1990-2, RSA Data Security, Inc. All rights reserved.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

This is derived from the RSA Data Security, Inc. MD4 Message-Digest Algorithm.
License to copy and use the original software is granted provided that it is
identified as the RSA Data Security, Inc. MD4 Message-Digest Algorithm in all
material mentioning or referencing the software or this function. License is
also granted to make and use derivative works provided that such works are
identified as derived from the RSA Data Security, Inc. MD4 Message-Digest
Algorithm in all material mentioning or referencing the derived work.

RSA Data Security, Inc. makes no representations concerning either the
merchantability of this software or the suitability of this software for any
particular purpose. It is provided as is without express or implied warranty
of any kind. These notices must be retained in any copies of any part of this
documentation and/or software.

The Quake II integration of this algorithm and this MiniLang adaptation are
distributed with the GPL-2.0-or-later port sources; see LICENSE.md.
*/
package miniquake2.qcommon.checksum

import miniquake2.qcommon.byteio as bio

/// Add 32.
/// @param a a value consumed by this operation.
/// @param b b value consumed by this operation.
function inline add32(a, b)
  return (a + b) & 0xffffffff
end function

/// Rotate left.
/// @param value Value consumed or transformed by the operation.
/// @param count Number of items or units to process.
function inline rotateLeft(value, count)
  value = value & 0xffffffff
  return ((value << count) | (value >> (32 - count))) & 0xffffffff
end function

/// Choose state.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param z z value consumed by this operation.
function inline choose(x, y, z)
  return (x & y) | ((~x) & z)
end function

/// Return the majority value.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param z z value consumed by this operation.
function inline majority(x, y, z)
  return (x & y) | (x & z) | (y & z)
end function

/// Return the parity value.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param z z value consumed by this operation.
function inline parity(x, y, z)
  return x ^ y ^ z
end function

/// Return the round 1 value.
/// @param a a value consumed by this operation.
/// @param b b value consumed by this operation.
/// @param c c value consumed by this operation.
/// @param d d value consumed by this operation.
/// @param word word value consumed by this operation.
/// @param shift shift value consumed by this operation.
function round1(a, b, c, d, word, shift)
  return rotateLeft(add32(add32(a, choose(b, c, d)), word), shift)
end function

/// Return the round 2 value.
/// @param a a value consumed by this operation.
/// @param b b value consumed by this operation.
/// @param c c value consumed by this operation.
/// @param d d value consumed by this operation.
/// @param word word value consumed by this operation.
/// @param shift shift value consumed by this operation.
function round2(a, b, c, d, word, shift)
  value = add32(add32(a, majority(b, c, d)), word)
  return rotateLeft(add32(value, 0x5a827999), shift)
end function

/// Return the round 3 value.
/// @param a a value consumed by this operation.
/// @param b b value consumed by this operation.
/// @param c c value consumed by this operation.
/// @param d d value consumed by this operation.
/// @param word word value consumed by this operation.
/// @param shift shift value consumed by this operation.
function round3(a, b, c, d, word, shift)
  value = add32(add32(a, parity(b, c, d)), word)
  return rotateLeft(add32(value, 0x6ed9eba1), shift)
end function

/// Transform state.
/// @param state Mutable state inspected or updated by the operation.
/// @param block block value consumed by this operation.
/// @param offset Zero-based offset at which processing starts.
function transform(state, block, offset)
  // Keep transform phases explicit: validate inputs, update owned state, then publish the result.
  words = array(16, 0)
  index = 0
  while index < 16
    words[index] = bio.u32(block, offset + index * 4)
    index = index + 1
  end while

  originalA = state[0]
  originalB = state[1]
  originalC = state[2]
  originalD = state[3]
  a = originalA
  b = originalB
  c = originalC
  d = originalD

  shifts = [3, 7, 11, 19]
  index = 0
  while index < 16
    shift = shifts[index & 3]
    if (index & 3) == 0 then
      a = round1(a, b, c, d, words[index], shift)
    else if (index & 3) == 1 then
      d = round1(d, a, b, c, words[index], shift)
    else if (index & 3) == 2 then
      c = round1(c, d, a, b, words[index], shift)
    else
      b = round1(b, c, d, a, words[index], shift)
    end if
    index = index + 1
  end while

  schedule2 = [0, 4, 8, 12, 1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15]
  shifts = [3, 5, 9, 13]
  index = 0
  while index < 16
    word = words[schedule2[index]]
    shift = shifts[index & 3]
    if (index & 3) == 0 then
      a = round2(a, b, c, d, word, shift)
    else if (index & 3) == 1 then
      d = round2(d, a, b, c, word, shift)
    else if (index & 3) == 2 then
      c = round2(c, d, a, b, word, shift)
    else
      b = round2(b, c, d, a, word, shift)
    end if
    index = index + 1
  end while

  schedule3 = [0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15]
  shifts = [3, 9, 11, 15]
  index = 0
  while index < 16
    word = words[schedule3[index]]
    shift = shifts[index & 3]
    if (index & 3) == 0 then
      a = round3(a, b, c, d, word, shift)
    else if (index & 3) == 1 then
      d = round3(d, a, b, c, word, shift)
    else if (index & 3) == 2 then
      c = round3(c, d, a, b, word, shift)
    else
      b = round3(b, c, d, a, word, shift)
    end if
    index = index + 1
  end while

  state[0] = add32(originalA, a)
  state[1] = add32(originalB, b)
  state[2] = add32(originalC, c)
  state[3] = add32(originalD, d)
  return state
end function

/// Return the md 4 value.
/// @param data Input data consumed by the operation.
/// @param offset Zero-based offset at which processing starts.
/// @param count Number of items or units to process.
function md4(data, offset, count)
  bio.requireRange(data, offset, count)

  paddedLength = count + 9
  while (paddedLength & 63) != 0
    paddedLength = paddedLength + 1
  end while
  padded = bytes(paddedLength)
  if count > 0 then bio.copyInto(padded, 0, data, offset, count) end if
  padded[count] = 0x80
  bio.putU32(padded, paddedLength - 8, (count << 3) & 0xffffffff)
  bio.putU32(padded, paddedLength - 4, (count >> 29) & 0xffffffff)

  state = [0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476]
  blockOffset = 0
  while blockOffset < paddedLength
    transform(state, padded, blockOffset)
    blockOffset = blockOffset + 64
  end while

  digest = bytes(16)
  bio.putU32(digest, 0, state[0])
  bio.putU32(digest, 4, state[1])
  bio.putU32(digest, 8, state[2])
  bio.putU32(digest, 12, state[3])
  return digest
end function

/// Return the block checksum value.
/// @param data Input data consumed by the operation.
/// @param offset Zero-based offset at which processing starts.
/// @param count Number of items or units to process.
function blockChecksum(data, offset, count)
  digest = md4(data, offset, count)
  return bio.u32(digest, 0) ^ bio.u32(digest, 4) ^ bio.u32(digest, 8) ^ bio.u32(digest, 12)
end function

/// Return the com block checksum value.
/// @param data Input data consumed by the operation.
/// @param offset Zero-based offset at which processing starts.
/// @param count Number of items or units to process.
function Com_BlockChecksum(data, offset, count)
  return blockChecksum(data, offset, count)
end function
