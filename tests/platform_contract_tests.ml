/* Asset-free timer and two-socket UDP platform integration. */
import miniquake2.platform.system as system
import miniquake2.platform.udp as udp

function assertEqual(actual, expected, name)
  if actual != expected then return error(9920, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(9921, name + ": expected true") end if
  return true
end function

function testClock()
  clock = system.createClock()
  before = system.counter(clock)
  system.sleep(2)
  after = system.counter(clock)
  assertTrue(after > before, "monotonic counter")
  assertTrue(system.handleCount() > 0, "process handle count")
  return true
end function

function testUdpLoopback()
  server = udp.open("127.0.0.1", 0)
  client = udp.open("127.0.0.1", 0)
  payload = bytes([81, 50, 45, 85, 68, 80])
  udp.send(client, "127.0.0.1", server.port, payload)
  packet = void
  attempts = 0
  while packet is void and attempts < 100
    packet = udp.receive(server, 1400)
    if packet is void then system.sleep(1) end if
    attempts = attempts + 1
  end while
  udp.close(client)
  udp.close(server)
  assertTrue(packet is not void, "loopback packet received")
  assertEqual(decode(packet.data), "Q2-UDP", "loopback payload")
  assertEqual(packet.address, "127.0.0.1", "loopback source address")
  return true
end function

testClock()
testUdpLoopback()
print "platform_contract_tests: PASS"
