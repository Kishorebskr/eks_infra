const http = require("http");

// ✅ Use port 3000 to match your Kubernetes Service
const port = 3000;

http.createServer((req, res) => {
  res.writeHead(200, {"Content-Type": "text/plain"});
  res.end("Hello from EKS test-app!\n");
})
// ✅ Bind to 0.0.0.0 so it listens on all interfaces (not just localhost)
.listen(port, "0.0.0.0", () => {
  console.log(`Server running on port ${port}`);
});
