/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* PMove scalar vector reads must not allocate temporary component arrays. */
import miniquake2.qcommon.types as pvallocqt
import miniquake2.physics.vector as pvallocvector

function pvallocAssert(value, name)
  if not value then return error(2851, name) end if
  return true
end function

pvallocFirst = pvallocqt.Vec3(1, 2, 3)
pvallocSecond = pvallocqt.Vec3(4, 5, 6)
pvallocWarm = 0
while pvallocWarm < 64
  pvallocvector.dot(pvallocFirst, pvallocSecond)
  pvallocvector.component(pvallocFirst, pvallocWarm % 3)
  pvallocWarm = pvallocWarm + 1
end while

pvallocBefore = heap_bytes_used()
pvallocTotal = 0
pvallocIndex = 0
while pvallocIndex < 100000
  pvallocTotal = pvallocTotal + pvallocvector.dot(pvallocFirst, pvallocSecond)
  pvallocTotal = pvallocTotal + pvallocvector.component(pvallocFirst,
    pvallocIndex % 3)
  pvallocIndex = pvallocIndex + 1
end while
pvallocAfter = heap_bytes_used()

pvallocAssert(pvallocTotal == 3399999,
  "allocation gate changed vector scalar semantics")
pvallocAssert(pvallocAfter - pvallocBefore <= 4096,
  "vector scalar reads allocated managed component arrays")
pvallocAssert(try(pvallocvector.dot(void, pvallocSecond)) is error,
  "vector validation accepted void")

print("physics_vector_allocation_tests: PASS")
