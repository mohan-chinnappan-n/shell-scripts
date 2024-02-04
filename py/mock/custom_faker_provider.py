"""
Script: custom_faker_provider.py
Author: Mohan Chinnappan
ref: https://pypi.org/project/Faker/
--------------------------------------------------------------------------

Description:
    This script demonstrates the creation of a dynamic provider for Python Faker,
    allowing the user to specify custom elements via the command line.

Usage:
    python custom_faker_provider.py element1 element2 element3 ...

Arguments:
    element1, element2, element3, ...:
        Custom elements to be used in the dynamic provider.

Example:
    python custom_faker_provider.py doctor nurse surgeon
    python custom_faker_provider.py 'open' 'closed won' 'closed lost'

Dependencies:
    - Faker library (Install with: pip install Faker)
"""

from faker import Faker
from faker.providers import DynamicProvider
import sys

class CustomDynamicProvider(DynamicProvider):
    def __init__(self, provider_name, elements):
        super().__init__(provider_name)
        self.elements = elements

# Check if elements are provided in the command line arguments
if len(sys.argv) < 2:
    print("Usage: python custom_faker_provider.py element1 element2 element3 ...")
    sys.exit(1)

elements = sys.argv[1:]

# Create a dynamic provider with elements from command line
custom_provider = CustomDynamicProvider(provider_name="custom_provider", elements=elements)

# Create a Faker instance
fake = Faker()

# Add the custom provider to the Faker instance
fake.add_provider(custom_provider)

# Now you can use the custom provider in your Faker instance
print(fake.custom_provider())
