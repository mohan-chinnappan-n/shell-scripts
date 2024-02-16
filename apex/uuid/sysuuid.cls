UUID randomUuid = UUID.randomUUID();
// Prints the UUID string that was randomly generated
system.debug(randomUuid);

String uuidStr = randomUUID.toString();

UUID fromStr = UUID.fromString(uuidStr);

Assert.areEqual(randomUuid, fromStr);