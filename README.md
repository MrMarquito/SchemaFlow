# SchemaFlow 🚀

A high-performance, interactive **Visual SQL Schema Designer** built from scratch using **Flutter Web**. 

SchemaFlow allows developers to visually architect database relationships on an infinite canvas and instantly transpile the visual layout into production-ready, formatted ANSI-SQL DDL scripts.

---

## 🛠️ Key Engineering Features

* **Custom Vector Engine:** Built using Flutter's low-level graphics `CustomPainter` to calculate coordinate paths and render real-time, anti-aliased cubic bezier lines connecting tables.
* **Fluid 2D Canvas Dragging:** Implements localized structural coordinate manipulation using native spatial multi-input gesture tracking (`onPanUpdate`) for pixel-perfect desktop mouse dragging.
* **Live Transpilation Pipeline:** Features a custom lexical string compiler that performs synchronous relational mapping over canvas data objects to output clean SQL code on the fly.
* **Zero External Dependencies:** Built entirely using native Flutter and Dart core APIs, demonstrating deep mastery of framework fundamentals, state architecture, and rendering lifecycles.

---

## 📐 Architecture Overview

SchemaFlow utilizes a decoupled, data-driven architecture to keep rendering lightweight and prevent execution bottlenecks:

```text
       [ State Controller ] ─── (Compiles State Modifications)
                │
       ┌────────┴────────┐
       ▼                 ▼
[ Infinite Canvas ]   [ Live SQL Terminal ]
  ├─ CustomPainter       └─ Formatted Text Stream
  └─ Table Nodes (Gestures)
