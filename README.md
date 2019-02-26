![Example EMVizLogo.png](EMVizLogo.png)

EMViz (Early Music Visualization) provides built-in pattern recognition for symbolic music based on a contour recursion algorithm by Carter-Enyi (2016) producing visualizations of musical form using arc diagrams, as proposed by Wattenberg (2002). The algorithm brings together contour theory (Morris 1987, Quinn 1996, Schultz 2013) with studies of melodic
accent (Thomassen 1982, Huron 2006). Symbolic music data (.midi, .xml) from various sources (including ELVIS at McGill and the Yale Classical Archives Corpus) may be imported, analyzed and visualized in a matter of minutes. Arc diagram visualizations in the supplemental materials include music from the Liber Usualis, Josquin des Prez and J. S. Bach.

## Getting Started

Mac OSX version:
https://morehousecollege.box.com/s/3ziy19h8n36l54oza5fcesx2f9z7y2yg

Windows version:
https://morehousecollege.box.com/s/cd2t5kb5xt4e3f7zsd0zcnbat2e9b1vw

Or github repository:
https://github.com/carterenyi/emviz

### Prerequisites

If you have MATLAB 2017b, you will not need to install MATLAB Runtime and may also run individual scripts (source code) from the github repository.

### Installing

Detailed instructions for installation on Windows:
1.     You will need a web connection to complete installation because MATLAB Runtime (also free) will also be downloaded and installed when you run the application installer 
2.      At the link above, download the “EMVizWindows” folder or “EMVizWindows.zip” (and unzip)
3.      Find the “AppInstaller” folder and double-click “MyApplicationInstall_web.exe”. 
4.      Because this software is not from an “App Store”, you will likely need to override some security preferences after expanding/unzipping and clicking on the.exe, to do this right-click or control-click and select “Run as administrator”
5.      The installation process (which requires an internet connection) may take 5 to 20 minutes depending on the download speed of your internet connection (it is downloading MATLAB Runtime so your computer can interpret the source code)


## Running the tests

MIDI files for testing are included at the link above. You should be able to produce the images in
[paper.md](https://github.com/carterenyi/emviz/blob/master/paper.md)

## Deployment

Before importing MIDI files of your own or those found through the Internet, it is recommended that you test basic functionality using one of the provided MIDI files, specifically:
LiberUsualis_Alleluia_Exsultate.mid
1.	Click “Select the MIDI file”
2.	Use default settings (i.e. selection box on “Use Pitch” and minimum cardinality at “5”)
3.	Click “Run Analysis and Plot”
4.	Wait for analysis (this file is small so run time should be 5 to 10 seconds)
5.	When the diagram appears, compare it to the image below.
![Table of features of Wattenberg's Shape of Song, EMViz (released 2017) and ATAVizM (in development)](TestDiagram.png)
6.	Click “Export Data as CSV”, navigate to the folder with the MIDI file, open the CSV file with the same filename (ideally, with Microsoft Excel) and compare to the sample CSV output below.
![Table of features of Wattenberg's Shape of Song, EMViz (released 2017) and ATAVizM (in development)](TestCSVinTable.png)

## Built With

MATLAB 2018b Compiler

## Contributing

Please read [contributing.md](https://github.com/carterenyi/emviz/blob/master/contributing.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

* **Aaron Carter-Enyi** <carterenyi@gmail.com>

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/carterenyi/emviz/blob/master/LICENSE) file for details

## Acknowledgments

* Inspired by Martin Wattenberg's Shape of Song and the phonology of Niger-Congo (African) tone languages.
