# Generate an ESMF mesh

About
=====

TODO: why this is neede?

Steps
=====

1) Uses the supergrid, ocean mask, and topography to create a netCDF file with the nominal grid of the model:

```
python gen_nc_grid.py
```

2) Convert grid to a SCRIP convention file

```
module load ncl
ncl gen_scrip.ncl
```

3) Create an ESMF mesh

```
qsub create_mesh
```

If these scripts run successfully, you should see file "*_mesh_*.nc" in your directory.

