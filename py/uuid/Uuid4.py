import re
import random
import string


# python version of:
#  https://github.com/jongpie/ApexUUID/blob/main/apex-uuid/classes/Uuid.cls

class Uuid4:
    HEX_CHARACTERS = '0123456789abcdef'
    HEX_BASE = len(HEX_CHARACTERS)
    HEX_PREFIX = '0x'
    UUID_V4_LENGTH = 36
    UUID_V4_REGEX = r'[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}'

    def __init__(self, uuid_value=None):
        if uuid_value is None:
            self.value = self.generate_value()
        else:
            self.value = self.format_value(uuid_value)

    @staticmethod
    def format_value(unformatted_value):
        invalid_value_error = f"{unformatted_value} is not a valid UUID value"

        # Remove any non-alphanumeric characters
        unformatted_value = re.sub('[^a-zA-Z0-9]', '', unformatted_value)

        # Check if the unformatted value has the correct length
        if len(unformatted_value) != (Uuid4.UUID_V4_LENGTH - 4):
            raise UuidException(invalid_value_error)

        # UUID Pattern: 8-4-4-4-12
        formatted_value = '-'.join([
            unformatted_value[0:8],
            unformatted_value[8:12],
            unformatted_value[12:16],
            unformatted_value[16:20],
            unformatted_value[20:]
        ])

        formatted_value = formatted_value.lower()

        if not Uuid4.is_valid(formatted_value):
            raise UuidException(invalid_value_error)

        return formatted_value

    @staticmethod
    def is_valid(uuid_value):
        if not uuid_value:
            return False
        if len(uuid_value) != Uuid4.UUID_V4_LENGTH:
            return False

        uuid_pattern = re.compile(Uuid4.UUID_V4_REGEX)
        return bool(uuid_pattern.match(uuid_value))

    @staticmethod
    def value_of(uuid_value):
        return Uuid4(uuid_value)

    def get_shifted_hex_bits(self, hex_substring, lower_threshold, upper_threshold):
        shifted_integer_bits = (self.convert_hex_to_integer(hex_substring) & lower_threshold) | upper_threshold
        return self.convert_integer_to_hex(shifted_integer_bits)

    def convert_hex_to_integer(self, hex_value):
        hex_value = hex_value.lower()

        if hex_value.startswith(Uuid4.HEX_PREFIX):
            hex_value = hex_value[len(Uuid4.HEX_PREFIX):]

        integer_value = 0
        for hex_character in hex_value:
            hex_character_index = Uuid4.HEX_CHARACTERS.index(hex_character)
            integer_value = Uuid4.HEX_BASE * integer_value + hex_character_index

        return integer_value

    def convert_integer_to_hex(self, integer_value):
        hex_value = ''
        while integer_value > 0:
            hex_character_index = integer_value % Uuid4.HEX_BASE
            hex_value = Uuid4.HEX_CHARACTERS[hex_character_index] + hex_value
            integer_value //= Uuid4.HEX_BASE

        return hex_value

    def generate_value(self):
        hex_value = ''.join(random.choice(string.hexdigits) for _ in range(32))

        # Version Calculation: (i & 0x0f) | 0x40
        # Version Format: Always begins with 4
        version_shifted_hex_bits = self.get_shifted_hex_bits(hex_value[14:16], self.convert_hex_to_integer('0x0f'), self.convert_hex_to_integer('0x40'))

        # Variant Calculation: (i & 0x3f) | 0x80
        # Variant Format: Always begins with 8, 9, A, or B
        variant_shifted_hex_bits = self.get_shifted_hex_bits(hex_value[18:20], self.convert_hex_to_integer('0x3f'), self.convert_hex_to_integer('0x80'))

        uuid_value = '-'.join([
            hex_value[0:8],  # time-low
            hex_value[8:12],  # time-mid
            version_shifted_hex_bits,
            hex_value[14:16],  # time-high-and-version
            variant_shifted_hex_bits,
            hex_value[18:20],  # clock-seq-and-reserved + clock-seq-low
            hex_value[20:]  # node
        ])

        return self.format_value(uuid_value)

    @staticmethod
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
    Uuid4.example()
