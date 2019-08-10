# Curso de WRF-Python

Notebook de WRF-Python para el Curso de WRF en CONAE del 18 al 20 de Diciembre de 2017

Basado en:

[link a wrf-python-tutorial](https://github.com/NCAR/wrf_python_tutorial)

## Instalación

Para poder hacer el tutorial seguir las indicaciones de:

[link a instalación de wrf-python-tutorial](https://wrf-python.readthedocs.io/en/latest/tutorials/wrf_workshop_2017.html)

Seguir los pasos de instalación con los siguientes cambios:

#### Step 4: Set Up the Conda Environment

En este paso, en el punto 4, ejecutar:

```bash
conda create -n curso_wrf python=2.7 matplotlib=1.5.3 netcdf4 jupyter git wrf-python basemap numpy pandas xarray
```

En el punto 5, donde diga *tutorial_2017* poner *curso_wrf*

#### Step 5: Download the Student Workbook

En este paso, igual que antes, donde diga *tutorial_2017* cambiar por *curso_wrf*

En el punto 3, cambiar por:

```bash
git clone https://github.com/gonzigaran/curso-wrf-python.git
```


