# Datasets from "Optimal growth conditions of the haptophyte _Chrysochromulina leadbeateri_ causing massive fish mortality in Northern Norway" #




## Experimental design ##

The study used a high-throughput experimental design to screen the growth rates of the fish-killing haptophyte  _Chrysochromulina leadbeateri_, which caused massive fish mortality in Northern Norway in 1991 and 2019. The figure below shows a schematic depiction of the experimental design.

![Fig_2](https://github.com/Mr-Mathias-F/Chrysochromulina-leadbeateri-growth-rates/assets/74455376/ef3eca8c-c58d-4b80-b892-6dc4e201dd15)


## Data analysis ##

All files used for data processing, analysis and Arduino light panel programming are in the `Analysis` folder.

![Fig_5](https://github.com/Mr-Mathias-F/Chrysochromulina-leadbeateri-growth-rates/assets/74455376/a3bea697-2081-418b-a58f-aa1c22694da8)


## Datasets used in high-throughput _Chrysochromulina leadbeateri_ (HTCL) growth rate experiments ##

### **HTCL_dataset_metadata.csv** / **HTCL_dataset_metadata.xlsx** ###

Dataset with _Chrysochromulina leadbeateri_ chlorophyll-a measurement with full metadata.

Column description:

* **Date_Time** – Date (in **YYYY-MM-DD** format) and time (in **HH:MM:SS** format) for each _in vivo_ chlorophyll-a measurement
* **Date** – Date (in **YYYY-MM-DD** format) for each _in vivo_ chlorophyll-a measurement
* **Time** – Time (in **HHMM** format) for each _in vivo_ chlorophyll-a measurement
* **Experiment.x** – Experimental name
* **ID_unique**	– Unique well identifier for each plate (concatenation of well ID (Row and Col) with Plate.x)
* **Plate.x** –	Plate number in the experiment
* **ID** – Well identifier
* **Row** –	Well row
* **Col** –	Well column
* **Chl** – Measured _in vivo_ chlorophyll-a measurement in _Chrysochromulina leadbeateri_
* **Well** – Well identifier (identical to ID)
* **Plate.y** –	Plate number in the experiment (identical to Plate.x)
* **Light_panel** –	Identification of which light panel used	
* **Group**	– Taxonomic clade of species
* **Genus**	– Taxonomic genus of species
* **Species** –	Taxonomic species name
* **Strain_Experiment_Replicate** – Description of strain from which experiment and replicate (concatenation of Strain, Experiment.x and replicate)
* **Strain_Experiment** – Description of strain from which experiment (concatenation of Strain and Experiment.x)
* **Strain** – Strain of _Chrysochromulina leadbeateri_ used
* **Species_Strain** – Description of species and which strain (concatenation of Species and Strain)
* **Medium** – Medium used in the experiment	
* **Replicate**	– Identification of technical replicate within experiment for combination of culture condition
* **Salinity** – Salinity treatment of the medium
* **Temperature** –	Temperature treatment (°C)
* **Light_period** – Number of hours (h) with light on in a given day
* **Light_intensity** – Irradiance treatment (µmol m<sup>-2</sup> s<sup>-1</sup>)
* **Experiment.y** – Identification of experiment
* **Timepassed** – Time passed since starting experiment (based on the time of the first measurement)
* **Day** –	Time passed in number of days (rounded from Timepassed to integer)

### **metaPR2_Chrysochromulina_leadbeateri.csv** / **metaPR2_Chrysochromulina_leadbeateri.xlsx** ###

Extracted data from the metaPR2 dataset for species _Chrysochromulina leadbeateri_.

Column description:

* **depth** –
* **salinity** –
* **temperature** –
* **asv_code** –
* **n_reads_pct** –
* **longitude** –
* **latitude** –

### **HTCL_dataset_validation.csv** / **HTCL_dataset_validation.xlsx** ###

Dataset with _Chrysochromulina leadbeateri_ strain UIO394 _in vivo_ chlorophyll-a measurements and cell concentations (cells mL<sup>-1</sup>).

Column description:

* **Replicate** – Identification of replicate
* **Day** – Time passed (d) since experiment start
* **IVF_mean** – Mean _in vivo_ chlorophyll-a measurements of _Chrysochromulina leadbeateri_
* **IVF_sd** – Standard deviation of  mean _in vivo_ chlorophyll-a measurements for technical replicates
* **Cell_conc** – Cell concentration of _Chrysochromulina leadbeateri_ determined by manual cell counting (cells mL<sup>-1</sup>)
* **Species** – Taxonomic Species name
* **Temp** – Temperature (°C)
* **Salintiy** – Salinity of the medium
* **Date – Date** (in **DD-MM-YYYY** format)

### **HTCL_mumax.xlsx** ###

Dataset with _Chrysochromulina leadbeateri_ maximum specific growth rates obtained from the spline models.

Column description:

* **Strain** – Strain of _Chrysochromulina leadbeateri_ used
* **Salinity** – Salinity treatment of the medium
* **Temperature** – Temperature treatment (°C)
* **Irradiance** – Irradiance treatment (µmol m<sup>-2</sup> s<sup>-1</sup>)
* **Experiment ID** – Identification of experiment
* **Maximum specific growth rate** – The maximum specific growth rate (d<sup>-1</sup>) estimated for given combination of Strain, Salinity, Temperature, Irradiance and Experiment ID
* **Standard deviation** – Standard deviation of the maximum specific growth rates of all technical replicates for given combination of Strain, Salinity, Temperature, Irradiance and Experiment ID
