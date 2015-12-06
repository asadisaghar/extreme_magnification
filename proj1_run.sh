#!/bin/bash
## Generates the input file of 'Glafic' with changing 'INPUT.input'. 
## 'INPUT.input' needs to be in the same directory!!!
z_l=0.5		##lens redshift
z_s=8.0		##source redshift
for filter in 200 444
do
echo "JWST FILTER: F$filter W"
######SOURCE######
echo "Source Properties, consists of a Pop III stellar cluster surrounded by its HII region"
####POP III CLUSTER####
echo "Surface brightness profile of the [Pop III] stellar: (Options: point, gauss)"
read CLUStype
		START=$(date +%s)
##point
if [[ "$CLUStype" == 'point' ]]; then
	CLUStype_MATLAB=0
	if [[ "$filter" == '200' ]]; then
		PS_ftot=2.265e-14
	elif [[ "$filter" == '444' ]]; then
		PS_ftot=6.053e-15
	else
	exit
	fi
	echo 1 >fluxfile_$filter.dat
	echo $PS_ftot>>fluxfile_$filter.dat
#echo $CLUStype_MATLAB
	##position of the cluster
	echo "X: (a number between -5 and 5)"
	read PS_X
	echo "Y: (a number between -5 and 5)"
	read PS_Y
		sed -e s/"PREFIX"/"$CLUStype"_"$filter"/g INP.input >$CLUStype'_'$filter'.input'		
		perl -pi -e s/"#point PS_z PS_X PS_Y"/"point PS_z PS_X PS_Y"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"startup 10 1 0"/"startup 10 1 1"/g $CLUStype'_'$filter'.input'
#		perl -pi -e s/"#0 0 0 0 0 0 0 0 0"/""/g $CLUStype'_'$filter'.input'
#		perl -pi -e s/"#0 0 0"/"0 0 0"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"PS_z"/"$z_s"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"PS_X"/"$PS_X"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"PS_Y"/"$PS_Y"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"fluxfile_filter"/"fluxfile_$filter.dat"/g $CLUStype'_'$filter'.input'

##gauss
elif [[ "$CLUStype" == 'gauss' ]]; then
	CLUStype_MATLAB=1
	if [[ "$filter" == '200' ]]; then
		G_ftot=2.265e-14
	elif [[ "$filter" == '444' ]]; then
		G_ftot=6.053e-15
	else
	exit
	fi
#	echo $G_ftot
#echo $CLUStype_MATLAB
	##position of the cluster
	echo "X: (a number between -5 and 5)"
	read G_X
	echo "Y: (a number between -5 and 5)"
	read G_Y
	echo "Eccentricity: (a number between 0 and 1)"
	read G_e
	echo "Position angle: (in radians)"
	read G_theta
	echo "Standard deviation(sigma): Physical effective radius (in kpc)"
	read G_sigma
	matlab -nodesktop -nosplash -r "sizes($G_sigma,$z_s);quit;"
	reset
	set -- $(<sizes.txt)
	G_sigma=$1
		sed -e s/"PREFIX"/"$CLUStype"_"$filter"/g INP.input >$CLUStype'_'$filter'.input'		
		perl -pi -e s/"#extend gauss G_z G_ftot G_X G_Y G_e G_theta G_sigma 0.0"/"extend gauss G_z G_ftot G_X G_Y G_e G_theta G_sigma 0.0"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"startup 10 1 0"/"startup 10 2 0"/g $CLUStype'_'$filter'.input'
#		perl -pi -e s/"#0 0 0 0 0 0 0 0 0"/"0 0 0 0 0 0 0 0 0"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"G_z"/"$z_s"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"G_ftot"/"$G_ftot"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"G_X"/"$G_X"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"G_Y"/"$G_Y"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"G_e"/"$G_e"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"G_theta"/"$G_theta"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"G_sigma"/"$G_sigma"/g $CLUStype'_'$filter'.input'

#		perl -pi -e s/"startup 10 2 0"/"startup 10 2 1"/g $CLUStype'_'$filter'.input'
#		perl -pi -e s/"#0 0 0 0 0 0 0 0 0"/""/g $CLUStype'_'$filter'.input'
#		perl -pi -e s/"#0 0 0"/"0 0 0"/g $CLUStype'_'$filter'.input'
#		perl -pi -e s/"#1point PS_z"/"#1point $z_s"/g $CLUStype'_'$filter'.input'
#		perl -pi -e s/"#1point $z_s PS_X"/"#1point $z_s $G_X"/g $CLUStype'_'$filter'.input'
#		perl -pi -e s/"#1point $z_s $G_X PS_Y"/"#1point $z_s $G_X $G_Y"/g $CLUStype'_'$filter'.input'
#		perl -pi -e s/"#1point $z_s $G_X $G_Y"/"point $z_s $G_X $G_Y"/g $CLUStype'_'$filter'.input'
#		perl -pi -e s/"fluxfile_filter"/"fluxfile_$filter.dat"/g $CLUStype'_'$filter'.input'
#		echo 1 >fluxfile_$filter.dat
#		echo $G_ftot>>fluxfile_$filter.dat
		
else
exit
fi		

####HII REGION####	
echo "Surface brightness profile of the Nebula: (Options: gauss, sersic, tophat)"
read NEBtype
##sersic
if [[ "$NEBtype" == 'sersic' ]]; then
	NEBtype_MATLAB=0
	if [[ "$filter" == '200' ]]; then
		Se_ftot=1.425e-13
	elif [[ "$filter" == '444' ]]; then
		Se_ftot=1.355e-13
	else
	exit
	fi
#echo $NEBtype_MATLAB
	##position of the nebula
	echo "X: (a number between -5 and 5)"
	read Se_X
	echo "Y: (a number between -5 and 5)"
	read Se_Y
	echo "Eccentricity: (a number between 0 and 1)"
	read Se_e
	echo "Position angle: (in radians)"
	read Se_theta
	echo "Physical effective radius: (in kpc)"
	read Se_Re
	matlab -nodesktop -nosplash -r "sizes($Se_Re,$z_s);quit;"
	reset
	set -- $(<sizes.txt)
	Se_re=$1
	echo "Sersic  power index: (n)"
	read Se_n
#		sed -e s/"PREFIX"/"$NEBtype"/g $CLUStype.input >$NEBtype'.input'		
		perl -pi -e s/"#extend sersic Se_z Se_ftot Se_X Se_Y Se_e Se_theta Se_re Se_n"/"extend sersic Se_z Se_ftot Se_X Se_Y Se_e Se_theta Se_re Se_n"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"startup 10 1 0"/"startup 10 2 0"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"#0 0 0 0 0 0 0 0 0"/"0 0 0 0 0 0 0 0 0"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"Se_z"/"$z_s"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"Se_ftot"/"$Se_ftot"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"Se_X"/"$Se_X"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"Se_Y"/"$Se_Y"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"Se_e"/"$Se_e"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"Se_theta"/"$Se_theta"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"Se_re"/"$Se_re"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"Se_n"/"$Se_n"/g $CLUStype'_'$filter'.input'
		
#		perl -pi -e s/"#2point PS_z PS_X PS_Y"/"point PS_z PS_X PS_Y"/g $CLUStype'_'$filter'.input'
#		perl -pi -e s/"startup 10 2 1"/"startup 10 2 2"/g $CLUStype'_'$filter'.input'
#		perl -pi -e s/"#0 0 0 0 0 0 0 0 0"/""/g $CLUStype'_'$filter'.input'
#		perl -pi -e s/"#0 0 0"/"0 0 0"/g $CLUStype'_'$filter'.input'
#		perl -pi -e s/"PS_z"/"$z_s"/g $CLUStype'_'$filter'.input'
#		perl -pi -e s/"PS_X"/"$Se_X"/g $CLUStype'_'$filter'.input'
#		perl -pi -e s/"PS_Y"/"$Se_Y"/g $CLUStype'_'$filter'.input'
#		perl -pi -e s/"fluxfile_filter"/"fluxfile_$filter.dat"/g $CLUStype'_'$filter'.input'
##		echo 2 >fluxfile_$filter.dat
#		echo $Se_ftot>>fluxfile_$filter.dat
		cp $CLUStype'_'$filter'.input' Gauss/in
		./glafic $CLUStype'_'$filter'.input'
		
		END=$(date +%s)
		DIFF=$(( $END - $START ))
		echo "*********$NEBtype - $CLUStype F$filter W took $DIFF seconds*********"
#		rm $CLUStype'_'$filter'.input'
##gauss
elif [[ "$NEBtype" == 'gauss' ]]; then
	CLUStype_MATLAB=1
	if [[ "$filter" == '200' ]]; then
		G2_ftot=2.265e-14
	elif [[ "$filter" == '444' ]]; then
		G2_ftot=6.053e-15
	else
	exit
	fi
	##position of the cluster
	echo "X: (a number between -5 and 5)"
	read G2_X
	echo "Y: (a number between -5 and 5)"
	read G2_Y
	echo "Eccentricity: (a number between 0 and 1)"
	read G2_e
	echo "Position angle: (in radians)"
	read G2_theta
	echo "Standard deviation(sigma): Physical effective radius (in kpc)"
	read G2_sigma
	matlab -nodesktop -nosplash -r "sizes($G_sigma,$z_s);quit;"
	reset
	set -- $(<sizes.txt)
	G2_sigma=$1
#		sed -e s/"PREFIX"/"$CLUStype"_"$filter"/g INP.input >$CLUStype'_'$filter'.input'		
		perl -pi -e s/"#extend gauss2 G2_z G2_ftot G2_X G2_Y G2_e G2_theta G2_sigma 0.0"/"extend gauss G2_z G2_ftot G2_X G2_Y G2_e G2_theta G2_sigma 0.0"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"startup 10 2 0"/"startup 10 2 0"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"#0 0 0 0 0 0 0 0 0"/"0 0 0 0 0 0 0 0 0"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"G2_z"/"$z_s"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"G2_ftot"/"$G2_ftot"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"G2_X"/"$G2_X"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"G2_Y"/"$G2_Y"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"G2_e"/"$G2_e"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"G2_theta"/"$G2_theta"/g $CLUStype'_'$filter'.input'
		perl -pi -e s/"G2_sigma"/"$G2_sigma"/g $CLUStype'_'$filter'.input'
		cp $CLUStype'_'$filter'.input' Sersic14/in
		./glafic $CLUStype'_'$filter'.input'
		
		END=$(date +%s)
		DIFF=$(( $END - $START ))
		echo "*********$NEBtype - $CLUStype F$filter W took $DIFF seconds*********"
else
exit
fi		

##gauss

##tophat

######LENS######
#echo 'Lensing cluster is being generated...'
#matlab -nodesktop -nosplash -r "lensing_cluster(filter,z_l);quit;"


done

#/afs/astro.su.se/u/saas9842/
