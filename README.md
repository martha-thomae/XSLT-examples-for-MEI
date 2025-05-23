# XSLT-examples-for-MEI

This repository contains examples of XSLT to convert MEI files into:
- Another MEI file ([`1_MEI-to-MEI`](./1_MEI-to-MEI) folder). This folder shows how to build the XSLT step by step. The step-by-step XSLT stylesheets are meant to be used over the [`0_input_files/CNW01.xml`](./0_input_files/CNW01.xml) file to make the appropriate changes for it to be consistent with MEI version 5.0. The fixed file can be seen in [`0_input_files/CNW01_fixed.xml`](./0_input_files/CNW01_fixed.xml). 
- An HTML file ([`2_MEI-to-HTML`](./2_MEI-to-HTML) folder). This folder also shows how to build the XSLT step by step. This is meant to be used with the "already fixed" CNW01 file obtained in the previous step: [`0_input_files/CNW01_fixed.xml`](./0_input_files/CNW01_fixed.xml).
- A text file ([`3_meiCensus`](./3_meiCensus) folder). This is an example of the use of XSLT to pull information from an MEI file. The XSLT pulls music information and provides a text file listing features like the number of measures, number of notes, chords, larges and smallest note duration, highest and lowest note, maximum number of staves per measure, etc. One can test this stylesheet with [`0_input_files/Bach-JS_Ein_feste_Burg.mei`](./0_input_files/Bach-JS_Ein_feste_Burg.mei).
- A TSV file ([`4_meiPitchDistribution`](./4_meiPitchDistribution) folder). The two XSLT stylesheets allow to present the pitch counts (when using [`meiPitchDistribution.xsl`](./4_meiPitchDistribution/meiPitchDistribution.xsl)) and the pitch class counts ([`meiPitchDistribution_02.xsl`](./4_meiPitchDistribution/meiPitchDistribution_02.xsl)) in a table-like format (just like when using CSV). One can also test these stylesheets with [`0_input_files/Bach-JS_Ein_feste_Burg.mei`](./0_input_files/Bach-JS_Ein_feste_Burg.mei). The TSV file can be imported into Excel for further processing. 

The first two folders deal with the `<meiHead>` part of the MEI file (the metadata), while the last two examples are meant to deal with the `<music>` part of the MEI file.

**All encoded material was provided by Perry Roland**, and divided into steps by Martha Thomae (together with the accompaning slides).
