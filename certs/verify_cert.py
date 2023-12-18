# util to verify private key and cert for matching
#--------------------------------------------------
# python verify_cert.py --help
# mohan chinnappan
import argparse
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography import x509

def load_private_key(file_path):
    with open(file_path, "rb") as key_file:
        private_key = serialization.load_pem_private_key(
            key_file.read(),
            password=None,
            backend=default_backend()
        )
    return private_key

def load_certificate(file_path):
    with open(file_path, "rb") as cert_file:
        certificate = x509.load_pem_x509_certificate(
            cert_file.read(),
            backend=default_backend()
        )
    return certificate

def check_key_cert_match(private_key, certificate):
    try:
        # Sign a message with the private key
        message = b"Some message to sign"
        signature = private_key.sign(
            message,
            padding.PKCS1v15(),
            algorithm=hashes.SHA256()
        )

        # Verify the signature using the public key
        certificate.public_key().verify(
            signature,
            message,
            padding.PKCS1v15(),
            algorithm=hashes.SHA256()
        )

        print("Private key and certificate match.")
        return True
    except Exception as e:
        print(f"Private key and certificate do not match: {e}")
        return False

def main():
    parser = argparse.ArgumentParser(description="Check if a private key and certificate match.")
    parser.add_argument("--private_key", required=True, help="Path to the private key file.")
    parser.add_argument("--certificate", required=True, help="Path to the certificate file.")
    
    args = parser.parse_args()

    private_key = load_private_key(args.private_key)
    certificate = load_certificate(args.certificate)

    check_key_cert_match(private_key, certificate)

if __name__ == "__main__":
    main()
