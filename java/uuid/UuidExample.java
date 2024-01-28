// UuidExample.java
public class UuidExample {
    public static void main(String[] args) {
        try {
            // Create a new UUID instance
            Uuid4 uuidInstance = new Uuid4();

            // Access the generated UUID
            String uuidValue = uuidInstance.getValue();
            System.out.println("Generated UUID: " + uuidValue);

            // Check if a UUID is valid
            boolean isValid = Uuid4.isValid(uuidValue);
            System.out.println("Is Valid UUID: " + isValid);

            // Format a UUID
            String unformattedUuid = "550e8400-e29b-41d4-a716-446655440000";
            String formattedUuid = Uuid4.formatValue(unformattedUuid);
            System.out.println("Formatted UUID: " + formattedUuid);

            // Create a UUID instance from a string
            Uuid4 uuidInstanceFromString = Uuid4.valueOf("550e8400-e29b-41d4-a716-446655440000");
            System.out.println("UUID from String: " + uuidInstanceFromString.getValue());

        } catch (Uuid4.UuidException e) {
            System.out.println("UuidException: " + e.getMessage());
        }
    }
}
