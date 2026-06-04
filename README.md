# Switch_Debouncer
Analog LTspice and Digital Verilog implementations of a switch debouncer

# Hardware Switch Debouncer: Analog & Digital Implementations
When a mechanical switch or button is pressed or released, the physical contacts metal-on-metal do not close instantly. Instead, they bounce rapidly for a few milliseconds, creating false transitions. This project showcases two distinct engineering solutions to filter out this noise and create a clean, single-pulse signal: an **Analog RC Filter with a Schmitt Trigger** and a **Digital Synchronized Counter System**.


## Analog Implementation (LTspice)
The analog solution relies on a hardware low-pass filter network followed by a hysteretic inverter to cleanly transition states.

### Circuit Setup
* Pull-Up & Filter Network: A 5V source utilizes a 10kΩ pull-up resistor (R1). A secondary 10kΩ resistor (R2) paired with a 1µF capacitor (C1) creates an RC low-pass filter with a time constant (τ = R × C) of roughly 10ms.
* Schmitt Trigger: An inverting Schmitt Trigger (A1) handles the filtered voltage. It features explicit switching thresholds (Vt = 2.5V) and hysteresis (Vh = 1V) to completely suppress output chattering as the capacitor slowly charges and discharges[cite: 20].
* Bounce Simulation: Mechanical bouncing is modeled accurately using a Piecewise Linear (PWL) voltage source driving a voltage-controlled switch model (BouncingButton) to replicate erratic connection intervals.

### Simulation Result
* Observation: The input node bounces wildly between 10ms and 13ms. The RC network smooths out these rapid spikes, and the Schmitt trigger ensures the output signal (Vout) performs one definitive, clean transition once the threshold criteria are satisfied.


## Digital Implementation (Verilog)
The digital solution implements an algorithmic approach to debouncing inside an FPGA using synchronous logic.

### Design Features
* Metastability Protection: A 2-stage shift-register synchronizer samples the asynchronous switch input to safeguard against metastability.
* Stabilization Counter: A 17-bit counter keeps track of stable cycles. If the synchronized input matches the current state, the counter clears. If the input flips, the counter increments.
* **Threshold Detection:** The output only updates when the switch remains constant across a full parameter timeout window (`max_count = 100000` cycles, translating to ~10ms at a 10MHz clock reference).

### Simulation Testbench
The testbench (`tb_debouncer.v`) overrides `max_count` down to 5 cycles for tracking optimization and applies explicit stimulus blocks that simulate mechanical contact bounces on both button-press and button-release sequences. The clock generation block establishes a clear 10 ns clock period.

### Simulation Results
* Observation: Despite the raw `sw` input line experiencing severe intermediate toggles, the system ignores the transients. The `clean_sw` logic drives high strictly after the specified stable validation period is completed.