# script to Convert a DER-encoded certificate to PEM format
## mohan chinnappan
#---------------------------------------------
import argparse
from cryptography import x509
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization

def convert_cert_to_pem(cert_path, output_path):
    with open(cert_path, "rb") as cert_file:
        cert_data = cert_file.read()

    # Load the certificate
    certificate = x509.load_der_x509_certificate(cert_data, default_backend())

    # Convert the certificate to PEM format
    pem_cert = certificate.public_bytes(encoding=serialization.Encoding.PEM)

    # Write the PEM-formatted certificate to the output file
    with open(output_path, "wb") as pem_file:
        pem_file.write(pem_cert)

def main():
    parser = argparse.ArgumentParser(description="Convert a DER-encoded certificate to PEM format.")
    parser.add_argument("--input_cert", required=True, help="Path to the DER-encoded certificate file.")
    parser.add_argument("--output_pem", required=True, help="Path to the output PEM-formatted certificate file.")

    args = parser.parse_args()

    convert_cert_to_pem(args.input_cert, args.output_pem)

if __name__ == "__main__":
    main()
