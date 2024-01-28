// Uuid4.java
import java.util.UUID;

public class Uuid4 {
    private String value;

    public Uuid4() {
        this.value = generateValue();
    }

    public Uuid4(String uuidValue) {
        this.value = formatValue(uuidValue);
    }

    public String getValue() {
        return this.value;
    }

    public static boolean isValid(String uuidValue) {
        try {
            UUID uuid = UUID.fromString(uuidValue);
            return uuid.toString().equals(uuidValue);
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    public static String formatValue(String unformattedValue) {
        try {
            UUID uuid = UUID.fromString(unformattedValue);
            return uuid.toString();
        } catch (IllegalArgumentException e) {
            throw new UuidException(unformattedValue + " is not a valid UUID value");
        }
    }

    public static Uuid4 valueOf(String uuidValue) {
        return new Uuid4(uuidValue);
    }

    private String generateValue() {
        UUID uuid = UUID.randomUUID();
        return uuid.toString();
    }

    public static class UuidException extends RuntimeException {
        public UuidException(String message) {
            super(message);
        }
    }
}

