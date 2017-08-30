
foreach ($ini in gc .\InisAppserver.txt) {
    cls
   (gc $ini).Replace('\apo\20170726_1','\apo\20170728_1')
   pause
}