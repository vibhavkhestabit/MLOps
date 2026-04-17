# Kernel Tuning Guide & Justification

## 1. Network Performance
* **Action:** Increased `somaxconn` from 128 to 65535. 
* **Justification:** This vastly expands the queue of allowed incoming connections, preventing dropped packets during high-traffic MLOps API bursts.
* **Before Metrics (Baseline):** Load Average was 1.51 (1-min). 
* **After Metrics:** (Expected to remain stable or drop under heavy API load due to larger queue).

## 2. Memory Management (Swappiness)
* **Action:** Reduced `vm.swappiness` from 60 to 10. 
* **Justification:** Commands the Kernel to aggressively avoid using the Hard Drive as overflow memory (Swap), forcing it to rely on physical RAM until it is 90% full.
* **Before Metrics (Baseline):** Swap Usage: 0 MB | Free RAM: 1407 MB. 
* **After Metrics:** (Swap usage is expected to remain at 0 MB even when memory consumption spikes during model training).

## 3. Security Restrictions
* **Action:** Enabled `kernel.dmesg_restrict`. 
* **Justification:** Prevents standard users from reading the system's core ring buffer logs, hiding valuable memory addresses from attackers.