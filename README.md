# UART-FPGA-Implementation

Hi friends 😉!!,
This project is implemented jointly by me and my friend Abhishek Zinzuvadiya [<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linkedin/linkedin-original.svg" height="24" width="24"/>](https://www.linkedin.com/in/abhishek-zinzuvadiya/).

This is a project that implements a UART serial communication between two FPGAs. It showcases a robust data path that includes data encryption, error-correcting code, and real-time error correction, ensuring reliable data transmission.
- Serial Communication (tx and rx modules): The design uses a simple three wire connections, namely CLK, DATA and GND.
    - CLK connection for having a proper baud rate.
    - DATA connection for half duplex communication.
    - GND connection for having a common reference of voltage for two FPGAs.
- Data Encryption (Encryption module): The data is encrypted before transmission, adding a layer of security to the communication link.
- Hamming Code Encoding (encoding module): A Hamming code is applied to the data, adding redundant bits that enable error detection and correction.
- Error Detection and Correction (decoding and syn modules): Upon reception, the system automatically calculates a syndrome to detect single-bit errors. The syndrome decoder then corrects the corrupted bit, ensuring the integrity of the data.

Hope this finds some help to you all!!
![Top level Schematic](/Implementation_images/top.JPG)
Fig: Top-level architecture of the UART communication system.

![Transmitter Schematic](/Implementation_images/tx_module.JPG)
Fig: Transmitter Architecture of the UART system.

![Receiver Schematic](/Implementation_images/rx_module.JPG)
Fig: Receiver Architecture of the UART system.

Thank you!! 🤜🤛
