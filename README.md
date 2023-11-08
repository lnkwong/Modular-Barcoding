# Modular-Barcoding

Use medcenter.r to generate a median-centered, unlogged output essentially reflecting fold-change values around the median. The output will also list the median and mean values across all samples at the rightmost columns.

Use itm.r to generate a data matrix containing 3 types of information: 1) the median-centered data, 2) the "collapsed" values for each module, and 3) the correlation of each gene to the collapsed value of each module. The input data must have the module annotation for each gene in the second column. See itm_manual.pdf for further details.

Use Heatmap macros.xlsm within Excel to automatically color cells based on the fold-change, either unlogged or log2. Use Alt-F11 to select and run a macro.
