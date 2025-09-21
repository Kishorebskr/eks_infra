const http = require("http");
const port = 3000;  // ✅ match Kubernetes service targetPort

http.createServer((req, res) => {
  res.writeHead(200, {"Content-Type": "text/plain"});
  res.end("Hello from EKS test-app!\n");
}).listen(port, "0.0.0.0", () => {   // ✅ must bind to 0.0.0.0
  console.log(`Server running on port ${port}`);
});
