from chgnet.model import CHGNet
from ase.io import read,write
from pymatgen.core import Structure
import argparse

def parse_arguments():
    parser = argparse.ArgumentParser(description="Read file and run inference.")
    parser.add_argument("file_location", help="Path to the input file")
    return parser.parse_args()

def run_inference(filepath):
    # Read the file using ase.io.read
    #atoms = read(filepath)
    structure = Structure.from_file(filepath)

    chgnet = CHGNet.load()
    prediction = chgnet.predict_structure(structure)
    e=prediction['e']
    print(f"Predicted energy is {e} eV")


def main(): 
    args = parse_arguments()
    filepath = args.file_location
    run_inference(filepath)

if __name__ == "__main__":
    main()