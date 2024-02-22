import argparse
from pdf2image import convert_from_path

def pdf_to_png(pdf_path, output_folder):
    pages = convert_from_path(pdf_path)

    for i, page in enumerate(pages):
        page.save(f"{output_folder}/page_{i + 1}.png", "PNG")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert PDF to PNG images")
    parser.add_argument("--pdf-path", type=str, required=True, help="Path to the input PDF file")
    parser.add_argument("--output-folder", type=str, required=True, help="Path to the output folder for PNG images")

    args = parser.parse_args()

    pdf_to_png(args.pdf_path, args.output_folder)
