#!/bin/bash
echo "List of svg files?"
read svgfiles

filen=$svgfiles.output
if [ -f $filen ]; then
 mv $filen $filen.bak
fi
#----------------------------------------------------------------------------------
# create cat-to-output-file function
#----------------------------------------------------------------------------------
catToFile(){
	cat >> $filen << EOT
$1
EOT
}

#----------------------------------------------------------------------------------
# write entries into output file
#----------------------------------------------------------------------------------
i=0
while read ifile; 
do
	i=`expr $i + 1`
	inkscape -D -z --file=$ifile --export-pdf=${ifile/.svg/}.pdf --export-latex
	echo -e "file $i: converted $ifile to \n\t ${ifile/.svg/}.pdf, \n\t ${ifile/.svg/}.pdf_tex"
	ifileA=${ifile/.svg/}
	ifileB=${ifileA/K516f-/}
	catToFile "\addcontentsline{toc}{subsection}{$ifileB}
\begin{figure}[H]
	\centering
	\def\svgwidth{\columnwidth}
	\input{${ifile/.svg}.pdf_tex}
\end{figure}
For audio (midi): \hyperref{./${ifile/.svg/}.mid}{}{}{${ifile/.svg/}.mid}
"
done < $svgfiles
###
##
#
