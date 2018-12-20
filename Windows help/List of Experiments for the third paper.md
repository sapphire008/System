# List of experiments for the third paper
1. Ca2+ photometry, step with no persistence, with CCh --> Ca2+ level recovered by 3 seconds
2. Persistent firing frequency are not affected step amplitude, duration, and # steps in CCh
  --> Bistable mode
  * *TODO*: 500ms vs. 2000ms reanalysis
3. Persistent firing with 4 sec delay does not change persistence frequency --> Mode change
4. Probability of PA recovery after 4-10 seconds: 50% recovery rate at around 6-8 second range
5. State change is reflected in membran potential --> conductance change / mode change
6. Increase extracellular Ca2+, decrease PA frequency --> Setting up for SK
  * *TODO*: analyze effect of number of spikes and AHP size before after Ca2+ increase
7. Still has SK in CCh
  * Control --> SK blocker
  * CCh --> + SK blocker: increase in firing rate.
  * *TODO*: re-acquire data with CCh + ML297 before after SK blocker. Match step amplitude AND frequency
8. SK activator
  * Control --> SK activator (*TODO* already have data, not thoroughly analyzed)
  * CCh --> SK activator (*TODO* analysis)
9. SK activator in CCh --> self terminating
  * [x] Example self terminating about 5-6 seconds
  * Cell attached example
  * 500ms with 12 seconds of hyperpolarization
10. ChR2 self termination
  * Similar self termination duration 6 seconds vs. 5 seconds
  * Initial firing rate, AHP, first spike latency, num spikes, Rin,
  * [x] do in both between all cells, and within mixed cells
  * Probably get 1 more CCh only cell
11. Computational model
  * Time window (~6 seconds decision point)
    - If ERG > SK --> PA
    - IF ERG < SK --> self terminating
  * *TODO*: Do natural stim. Can self termination also occur ?
