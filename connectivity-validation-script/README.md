## Usage
1. Download the script file (`test_ips.sh`) to your local machine or server.
2. Open a terminal and navigate to the directory where the script is located.
3. Make the script executable by running the following command: `chmod +x test_ips.sh`
4. Run the script with the relevant source region argument: `./test_ips.sh <source_region> [port]`
   - Replace `<source_region>` with either `westeurope` or `westus2`.
   - Optionally, you can specify a custom port for the connectivity check. If not provided, the default port 8071 will be used.

   Example: `./test_ips.sh westus2 5051`
5. The script will start the validation process and display the progress for each IP address and port. A checkmark (`✓`) indicates a successful connection, while `Timed out` indicates an unreachable IP or port.
6. Once the validation is complete, the script will summarize the results. If all IPs are reachable, a success message will be shown.
