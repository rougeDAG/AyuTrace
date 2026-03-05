# AyuTrace: The Transparent Ayurvedic Ecosystem

**Apps built to abholish the uncertainty in Ayurvedic medicine through "Farm-to-Bottle" traceability.**

Ayurvedic medicine often suffers from a "black box" manufacturing process, leading to a lack of trust among modern consumers regarding purity, sourcing, and potency. **AyuTrace** is an integrated system designed to bring absolute transparency to the Ayurvedic nutraceutical chain, ensuring that every tablet's journey—from the field to the patient—is explicit and verifiable.

---

## 🌿 The Vision
Our mission is to bridge the gap between ancient wellness and modern clinical trust. By implementing IoT technology at the farm level and tracking every touchpoint in the manufacturing process, we provide patients with a verifiable record of quality (*Shuddhata*) and potency (*Virya*). We want to show that Ayurveda comes from farms, not just factories, and be explicit about every step of the process.

---

## 🏗️ The System Architecture
AyuTrace is envisioned as a multi-stakeholder ecosystem. While the current build focuses on the **Patient App**, the full system is designed to integrate the following:

### 📱 Active Module
* **Patient App (Current Focus):** A discovery and transparency hub where patients can browse products, interact with an AI Product Assistant, and view the real-time lifecycle of their medicine.

### 🛠️ Future Developments (To Be Worked On)
* **Farmer & IoT Portal:** An interface for farmers to log harvesting data, integrated with IoT sensors to monitor soil quality and curing temperatures directly from the fields.
* **Merchant & Delivery App:** A dedicated logistics tracker for merchants to manage inventory and for delivery partners to ensure the chain of custody remains intact during transit.
* **Doctor Prescription Portal:** A space for practitioners to upload digital prescriptions and validate the specific formulations being used by their patients, closing the loop between diagnosis and authentic medicine.

---

## 🚀 Key Features (Patient App)
* **Transparency Timeline:** A visual breakdown of the product’s journey: Harvesting ➔ Drying ➔ Processing ➔ Packaging.
* **AI Product Assistant:** A conversational agent that clarifies ingredients, dosage, and AYUSH licensing information.
* **Smart Search:** Filter products based on health goals and transparency ratings.
* **QR Traceability (Planned):** Scan physical medicine bottles to instantly unlock their specific batch history.

---

## 🛠️ Technical Implementation
This project is built using a **Clean Architecture** approach to ensure the system is scalable, testable, and independent of external frameworks.

### SOLID Principles & Design Patterns
To maintain a high-quality codebase, we strictly adhere to:
* **Single Responsibility Principle (SRP):** Every class, from Cubits to Repositories, has a single, well-defined purpose.
* **Dependency Inversion Principle (DIP):** High-level business logic does not depend on low-level data sources (like Firebase or APIs). Both depend on abstractions.
* **Clean Architecture Layers:**
    * **Domain:** The heart of the app containing Entities and Use Cases. Completely independent of Flutter and external libraries.
    * **Data:** Implements repository contracts and handles API/Firebase integrations.
    * **Presentation:** Manages UI and State (BLoC/Cubit).
* **Dependency Injection (DI) Container:** Managed via an Injection Container (Get_it) to decouple object creation from usage. This allows us to "inject" different implementations of a repository (e.g., a Mock version for testing vs. a Firebase version for production) without changing the UI code.

---

## 📸 Screen Gallery
<img width="200" alt="Screenshot_1772725244" src="https://github.com/user-attachments/assets/d7e775ce-3144-4986-8904-b04ff909e070" />
<img width="200" alt="Screenshot_1772725523" src="https://github.com/user-attachments/assets/360ec16e-79a5-4fd7-9600-8049093e7ed8" />
<img width="200" alt="Screenshot_1772725580" src="https://github.com/user-attachments/assets/b0d0d09b-9516-4d6c-8c00-162dc986d488" />
<img width="200" alt="Screenshot_1772725585" src="https://github.com/user-attachments/assets/b29cf0c8-5694-4d89-8912-0242538c9333" />
<img width="200" alt="Screenshot_1772725588" src="https://github.com/user-attachments/assets/29c99978-53a5-4cbd-89a0-834d172065fb" />
<img width="200" alt="Screenshot_1772725595" src="https://github.com/user-attachments/assets/8d8efc92-c113-4cc5-a2d9-4e16cb1b7c4b" />
<img width="200" alt="Screenshot_1772725598" src="https://github.com/user-attachments/assets/21f071c7-5bd9-4a74-9318-15e628ef189a" />
<img width="200" alt="Screenshot_1772725601" src="https://github.com/user-attachments/assets/6832fa7e-d3a3-4bc9-87e6-535215ac954c" />
<img width="200" alt="Screenshot_1772725606" src="https://github.com/user-attachments/assets/41c3ec50-f78a-4ecd-b6f0-6ea6747714f9" />
<img width="200" alt="Screenshot_1772725612" src="https://github.com/user-attachments/assets/5479b76f-6a08-4101-a354-a480ddebbd0b" />
<img width="200" alt="Screenshot_1772725624" src="https://github.com/user-attachments/assets/1986894e-f0cf-44d1-9300-a1974e5c3b5e" />
<img width="200" alt="Screenshot_1772725627" src="https://github.com/user-attachments/assets/bf3d57d2-d74e-4d08-9fbe-cb57d5f85c71" />



---

## 📈 Roadmap
- [ ] Integration of live IoT sensor data for drying/grinding stages (Farmer Portal).
- [ ] Development of the Doctor and Merchant/Delivery mobile modules.
- [ ] QR code scanning functionality for batch-specific tracking.
- [ ] Implementation of blockchain for immutable supply chain records.

---

## 🤝 Contact & Contribution
I am building **AyuTrace** to make Ayurveda trustable for the common people. If you are interested in the intersection of HealthTech, IoT, and Traditional Medicine, feel free to reach out!
Email: harisai.senthil@gmail.com (or) harisai.senthil2024@vitstudent.ac.in
