<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Valentine?</title>

<style>
  body {
    margin: 0;
    min-height: 100vh;
    display: grid;
    place-items: center;
    background: radial-gradient(circle at top, #3b0a2a, #05020a);
    font-family: system-ui, sans-serif;
    overflow: hidden;
    color: white;
  }

  .card {
    background: rgba(255,255,255,0.08);
    border-radius: 18px;
    padding: 26px;
    text-align: center;
    width: min(520px, 90vw);
    box-shadow: 0 20px 60px rgba(0,0,0,0.6);
    z-index: 1;
  }

  h1 { margin-bottom: 18px; font-size: clamp(22px, 4vw, 32px); }

  .stage {
    position: relative;
    height: 140px;
    background: rgba(0,0,0,0.25);
    border-radius: 14px;
    overflow: hidden;
  }

  button {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    padding: 12px 20px;
    border-radius: 999px;
    border: none;
    font-size: 16px;
    font-weight: 700;
    cursor: pointer;
  }

  #yes { left: 20%; background: #ff4d88; color: white; }
  #no  { left: 60%; background: #555; color: white; }

  /* Overlay */
  .overlay {
    position: fixed;
    inset: 0;
    display: none;
    place-items: center;
    background: rgba(0,0,0,0.88);
    z-index: 999;
    overflow: hidden;
  }
  .overlay.show { display: grid; }

  /* Smaller GIF */
  .boom {
    position: relative;
    width: min(420px, 80vw);
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 20px 70px rgba(0,0,0,0.7);
    z-index: 1;
  }
  .boom img { width: 100%; display: block; }

  /* Floating text ABOVE everything */
  .floatText {
    position: fixed;           /* IMPORTANT: fixed so it always shows in overlay */
    z-index: 2000;             /* higher than overlay + gif */
    left: 50vw;
    top: 85vh;
    transform: translate(-50%, -50%);
    pointer-events: none;
    font-weight: 900;
    white-space: nowrap;
    font-size: clamp(30px, 7vw, 64px);
    color: #ff77aa;
    text-shadow:
      0 0 10px rgba(255,120,170,0.95),
      0 0 25px rgba(255,120,170,0.85),
      0 10px 40px rgba(0,0,0,0.95);
    animation: drift linear forwards;
  }

  @keyframes drift {
    from { transform: translate(-50%, 0) scale(1); opacity: 1; }
    to   { transform: translate(-50%, -120vh) scale(1.25); opacity: 0; }
  }

  /* Firework sparks */
  .spark {
    position: fixed;
    z-index: 1500;
    width: 6px;
    height: 6px;
    border-radius: 50%;
    pointer-events: none;
    animation: sparkOut 900ms ease-out forwards;
    box-shadow: 0 0 18px currentColor;
  }

  @keyframes sparkOut {
    from { transform: translate(0,0) scale(1); opacity: 1; }
    to   { transform: translate(var(--dx), var(--dy)) scale(0.2); opacity: 0; }
  }
</style>
</head>

<body>

<div class="card">
  <h1>Zaya will you be my valentine?</h1>
  <div class="stage" id="stage">
    <button id="yes">Yes</button>
    <button id="no">No</button>
  </div>
</div>

<div class="overlay" id="overlay">
  <div class="boom">
    <img src="https://media.giphy.com/media/26ufdipQqU2lhNA4g/giphy.gif" alt="Mind blown fireworks">
  </div>
</div>

<script>
  const stage = document.getElementById("stage");
  const noBtn = document.getElementById("no");
  const yesBtn = document.getElementById("yes");
  const overlay = document.getElementById("overlay");

  // No button dodges
  function moveNo() {
    const s = stage.getBoundingClientRect();
    const b = noBtn.getBoundingClientRect();
    noBtn.style.left = Math.random() * (s.width - b.width) + "px";
    noBtn.style.top  = Math.random() * (s.height - b.height) + "px";
    noBtn.style.transform = "none";
  }
  noBtn.addEventListener("mouseenter", moveNo);
  stage.addEventListener("mousemove", e => {
    const r = noBtn.getBoundingClientRect();
    const d = Math.hypot(
      e.clientX - (r.left + r.width / 2),
      e.clientY - (r.top + r.height / 2)
    );
    if (d < 90) moveNo();
  });

  // Floating text (appended to overlay, not body)
  function spawnText() {
    const el = document.createElement("div");
    el.className = "floatText";
    el.textContent = "Dhiraj + Zaya";

    // Random horizontal position; start near bottom
    el.style.left = (10 + Math.random() * 80) + "vw";
    el.style.top = (85 + Math.random() * 10) + "vh";
    el.style.animationDuration = (6 + Math.random() * 6) + "s";

    // Append to overlay so it's guaranteed visible when overlay is shown
    overlay.appendChild(el);
    setTimeout(() => el.remove(), 14000);
  }

  function burstText(n) {
    for (let i = 0; i < n; i++) {
      setTimeout(spawnText, i * 140);
    }
  }

  // Fireworks sparks
  function sparkBurst(x, y) {
    const colors = ["#ff4d88", "#ffd166", "#4dd6ff", "#baff4d", "#c77dff", "#ffffff"];
    for (let i = 0; i < 22; i++) {
      const s = document.createElement("div");
      s.className = "spark";
      s.style.left = x + "px";
      s.style.top = y + "px";
      s.style.color = colors[Math.floor(Math.random() * colors.length)];

      const angle = Math.random() * Math.PI * 2;
      const dist = 40 + Math.random() * 120;
      s.style.setProperty("--dx", Math.cos(angle) * dist + "px");
      s.style.setProperty("--dy", Math.sin(angle) * dist + "px");

      overlay.appendChild(s);
      setTimeout(() => s.remove(), 1000);
    }
  }

  let fireTimer = null;
  function startFireworks() {
    fireTimer = setInterval(() => {
      sparkBurst(
        window.innerWidth * (0.2 + Math.random() * 0.6),
        window.innerHeight * (0.2 + Math.random() * 0.5)
      );
    }, 500);
  }

  function stopFireworks() {
    clearInterval(fireTimer);
    fireTimer = null;
  }

  // Yes click
  yesBtn.addEventListener("click", () => {
    overlay.classList.add("show");
    startFireworks();

    // Force immediate visibility + repeated spawns
    spawnText();
    setTimeout(() => burstText(18), 250);
  });

  // Close overlay
  overlay.addEventListener("click", () => {
    overlay.classList.remove("show");
    stopFireworks();
    // Remove any leftover floating texts quickly
    overlay.querySelectorAll(".floatText").forEach(n => n.remove());
  });

  // Click sparks
  overlay.addEventListener("pointerdown", (e) => {
    sparkBurst(e.clientX, e.clientY);
  });
</script>

</body>
</html>

