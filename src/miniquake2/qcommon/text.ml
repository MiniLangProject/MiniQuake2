/* ASCII helpers used by command, cvar and filesystem paths. */
package miniquake2.qcommon.text

function lower(value)
  if typeof(value) != "string" then return error(3260, "lower requires text") end if
  qtextLowerValueHolder = value
  qtextLowerSourceHolder = bytes(qtextLowerValueHolder)
  qtextLowerLength = len(qtextLowerSourceHolder)
  qtextLowerOutputHolder = bytes(qtextLowerLength)
  qtextLowerIndex = 0
  while qtextLowerIndex < qtextLowerLength
    qtextLowerCharacter = qtextLowerSourceHolder[qtextLowerIndex]
    if qtextLowerCharacter >= 65 and qtextLowerCharacter <= 90 then qtextLowerCharacter = qtextLowerCharacter + 32 end if
    qtextLowerOutputHolder[qtextLowerIndex] = qtextLowerCharacter
    qtextLowerIndex = qtextLowerIndex + 1
  end while
  return decode(qtextLowerOutputHolder)
end function

function equalInsensitive(first, second)
  if typeof(first) != "string" or typeof(second) != "string" then return error(3261, "equalInsensitive requires text") end if
  qtextEqualFirstHolder = lower(first)
  qtextEqualSecondHolder = lower(second)
  return qtextEqualFirstHolder == qtextEqualSecondHolder
end function

function fixedString(data, offset, capacity)
  if typeof(data) != "bytes" or typeof(offset) != "int" or typeof(capacity) != "int" then
    return error(3262, "fixedString requires bytes and integer bounds")
  end if
  qtextFixedDataHolder = data
  qtextFixedOffset = offset
  qtextFixedCapacity = capacity
  qtextFixedDataLength = len(qtextFixedDataHolder)
  if qtextFixedOffset < 0 or qtextFixedCapacity < 0 or qtextFixedOffset > qtextFixedDataLength or qtextFixedCapacity > qtextFixedDataLength - qtextFixedOffset then return error(3200, "fixed string outside buffer") end if
  qtextFixedCount = 0
  while qtextFixedCount < qtextFixedCapacity and qtextFixedDataHolder[qtextFixedOffset + qtextFixedCount] != 0
    qtextFixedCount = qtextFixedCount + 1
  end while
  if qtextFixedCount == 0 then return "" end if
  qtextFixedSliceHolder = slice(qtextFixedDataHolder, qtextFixedOffset, qtextFixedCount)
  qtextFixedValueHolder = decode(qtextFixedSliceHolder)
  if qtextFixedValueHolder is void then return error(3201, "invalid fixed string") end if
  return qtextFixedValueHolder
end function

function startsWith(value, prefix)
  if typeof(value) != "string" or typeof(prefix) != "string" then return error(3263, "startsWith requires text") end if
  qtextStartsValueHolder = value
  qtextStartsPrefixHolder = prefix
  qtextStartsLeftHolder = bytes(qtextStartsValueHolder)
  qtextStartsRightHolder = bytes(qtextStartsPrefixHolder)
  qtextStartsLeftLength = len(qtextStartsLeftHolder)
  qtextStartsRightLength = len(qtextStartsRightHolder)
  if qtextStartsRightLength > qtextStartsLeftLength then return false end if
  qtextStartsIndex = 0
  while qtextStartsIndex < qtextStartsRightLength
    if qtextStartsLeftHolder[qtextStartsIndex] != qtextStartsRightHolder[qtextStartsIndex] then return false end if
    qtextStartsIndex = qtextStartsIndex + 1
  end while
  return true
end function
