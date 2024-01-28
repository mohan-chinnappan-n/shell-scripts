
from Uuid4 import Uuid4

def example():
        try:
            # Create a new UUID instance
            uuid_instance = Uuid4()

            # Access the generated UUID
            uuid_value = uuid_instance.value
            print(f"Generated UUID: {uuid_value}")

            # Check if a UUID is valid
            is_valid = Uuid4.is_valid(uuid_value)
            print(f"Is Valid UUID: {is_valid}")

            # Format a UUID
            unformatted_uuid = "550e8400-e29b-41d4-a716-446655440000"
            formatted_uuid = Uuid4.format_value(unformatted_uuid)
            print(f"Formatted UUID: {formatted_uuid}")

            # Create a UUID instance from a string
            uuid_instance_from_string = Uuid4.value_of("550e8400-e29b-41d4-a716-446655440000")
            print(f"UUID from String: {uuid_instance_from_string.value}")

        except UuidException as e:
            print(f"UuidException: {e}")

if __name__ == "__main__":
    example()