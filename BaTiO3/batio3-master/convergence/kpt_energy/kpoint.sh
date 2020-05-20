#!/bin/bash
#The materials modeling group of the Technical university of Kenya
for i in `seq -w 2 1 24`
do 
	mkdir $i
	cd $i
	cp ../*.psml .
        cp ../BaTiO3basis.fdf .
	echo "running kpt for $i"
cat >BaTiO3.fdf <<EOF
SystemName      Barium titanate (BaTiO3) cubic structure
#               Cubic phase
#               PBE-SOL functional
#               Theoretical lattice constant obtained for the Hamann pseudos
#               (taken from the pseudo-dojo web page)
#               Mesh Cutoff: 600 Ry
#               Monkhorst-Pack grid: 6 x 6 x 6 ; displaced 0.5 0.5 0.5 

SystemLabel	BaTiO3
NumberOfSpecies	3
NumberOfAtoms	5
%block ChemicalSpeciesLabel
      1      56     Ba
      2      22     Ti
      3       8     O
%endblock ChemicalSpeciesLabel

%block PS.lmax
   Ba    3
   Ti    3
    O    3
%endblock PS.lmax

PAO.Basis  < BaTiO3basis.fdf

LatticeConstant       4.036 Ang    # Theoretical lattice constant for the
                                      #    cubic phase  
%block LatticeVectors
  1.00  0.00  0.00
  0.00  1.00  0.00
  0.00  0.00  1.00
%endblock LatticeVectors

AtomicCoordinatesFormat	     Fractional
%block AtomicCoordinatesAndAtomicSpecies
  0.00  0.00  0.00       1     137.327      Ba
  0.50  0.50  0.50       2      47.867      Ti
  0.00  0.50  0.50       3      15.9994     O
  0.50  0.00  0.50       3      15.9994     O
  0.50  0.50  0.00       3      15.9994     O
%endblock AtomicCoordinatesAndAtomicSpecies

WriteCoorStep           .true.        #  Write the atomic coordinates to 
                                      #     standard output at every 
                                      #     MD time step or relaxation step.

%block kgrid_Monkhorst_Pack
   $i  0  0  0.5
   0  $i  0  0.5
   0  0  $i  0.5
%endblock kgrid_Monkhorst_Pack
MeshCutoff             700 Ry
#
# DFT, Grid, SCF
#

%block GridCellSampling
 0.5 0.5 0.5
%endblock GridCellSampling

%block XC.cocktail                  # Perdew-Burke-Ernzerhof SOL functional taken from the libxc library
2
GGA LIBXC-0116-GGA_X_PBE_SOL  1.0  0.0
GGA LIBXC-0133-GGA_C_PBE_SOL  0.0  1.0
%endblock XC.cocktail
SolutionMethod diagon 
SolutionMethod = diagon
DM.Tolerance           1.d-4       # Tolerance in maximum difference
                                   # between input and output DM
MaxSCFIterations       100         # Maximum number of SCF Iterations
MD.TypeOfRun       CG               # We are going to perform a
                                    #   Conjugate Gradient (CG) minimization
MD.VariableCell    .true.           # Is the lattice relaxed together with
                                    #   the atomic coordinates?
MD.NumCGsteps      10               # Number of CG steps for
                                    #   coordinate optimization
MD.MaxStressTol    0.0005 eV/Ang**3 # Tolerance in the maximum
                                    #   stress in a MD.VariableCell CG optimi.
DM.MixingWeight 0.5
DM.NumberPulay  3

EOF
 siesta <BaTiO3.fdf> BaTiO3.out
cd ../
done


