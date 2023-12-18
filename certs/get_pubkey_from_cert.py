# script to: Extract public key from a certificate.
# mohan chinnappan
import argparse
from cryptography import x509
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization

def get_public_key_from_cert(cert_path):
    with open(cert_path, "rb") as cert_file:
        cert_data = cert_file.read()

    # Load the certificate
    certificate = x509.load_pem_x509_certificate(cert_data, default_backend())

    # Get the public key
    public_key = certificate.public_key()

    # Serialize the public key to PEM format
    pem_public_key = public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    )

    return pem_public_key.decode()

def main():
    parser = argparse.ArgumentParser(description="Extract public key from a certificate.")
    parser.add_argument("--cert", required=True, help="Path to the certificate file.")

    args = parser.parse_args()
    cert_path = args.cert

    try:
        public_key = get_public_key_from_cert(cert_path)
        print("Public key:")
        print(public_key)
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()
