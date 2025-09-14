# UART-FPGA-Implementation

Hi friends 😉!!,
This project is implemented jointly by me and my friend Abhishek Zinzuvadiya [![LinkedIn](https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linkedin/linkedin-original.svg)](https://www.linkedin.com/in/abhishek-zinzuvadiya/)
This is a project that implements a full-duplex communication system for FPGAs, inspired by UART serial communication. It showcases a robust data path that includes data encryption, error-correcting code, and real-time error correction, ensuring reliable data transmission.
- Serial Communication (tx and rx modules): The design uses a parallel-in, serial-out (PISO) transmitter and a serial-in, parallel-out (SIPO) receiver to send and receive data bit-by-bit.
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