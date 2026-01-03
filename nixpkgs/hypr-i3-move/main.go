package main

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net"
	"os"
)

// ActiveWindow represents the structure of the JSON output from Hyprland IPC
type ActiveWindow struct {
	Address string   `json:"address"`
	Grouped []string `json:"grouped"`
}

// IPCRequest represents a generic IPC request structure
type IPCRequest struct {
	Command string `json:"command"`
}

// IPCResponse represents a generic IPC response structure
type IPCResponse struct {
	Success bool        `json:"success"`
	Error   string      `json:"error"`
	Data    interface{} `json:"data"`
}

func getSocketPath() string {
	xdgRuntimeDir := os.Getenv("XDG_RUNTIME_DIR")
	hyprlandInstanceSignature := os.Getenv("HYPRLAND_INSTANCE_SIGNATURE")

	if xdgRuntimeDir == "" || hyprlandInstanceSignature == "" {
		log.Fatal("Required environment variables XDG_RUNTIME_DIR or HYPRLAND_INSTANCE_SIGNATURE are not set.")
	}

	return fmt.Sprintf("%s/hypr/%s/.socket.sock", xdgRuntimeDir, hyprlandInstanceSignature)
}

func sendIPCCommand(socketPath, command string, out interface{}) error {
	conn, err := net.Dial("unix", socketPath)
	if err != nil {
		return fmt.Errorf("failed to connect to socket: %v", err)
	}
	defer conn.Close()

	// Write the command as a plain string, followed by a newline
	if _, err := fmt.Fprintf(conn, "%s", command); err != nil {
		return fmt.Errorf("failed to send command: %v", err)
	}

	// Read the full response until EOF
	resp, err := io.ReadAll(conn)
	if err != nil {
		return fmt.Errorf("failed to read response: %v", err)
	}

	// Unmarshal the response into the provided output object
	if err := json.Unmarshal(resp, out); err != nil {
		return fmt.Errorf("failed to parse response: %v\nRaw response: %s", err, string(resp))
	}
	return nil
}

func main() {
    if len(os.Args) != 3 {
        fmt.Println("Usage: hypr-i3-move <focus|move> <direction>")
        os.Exit(1)
    }

    mode := os.Args[1]
    direction := os.Args[2]
    socketPath := getSocketPath()

    var activeWindow ActiveWindow
    if err := sendIPCCommand(socketPath, "j/activewindow", &activeWindow); err != nil {
        log.Fatalf("Failed to get active window: %v", err)
    }

    send := func(cmd string) {
        if err := sendIPCCommand(socketPath, cmd, nil); err != nil {
            log.Printf("Failed to send command '%s': %v", cmd, err)
        }
    }

    grouped := activeWindow.Grouped
    addr := activeWindow.Address

    switch mode {
    case "focus":
        if len(grouped) == 0 {
            send(fmt.Sprintf("dispatch movefocus %s", direction))
            return
        }

        switch {
        case (direction == "l" || direction == "u") && addr == grouped[0]:
            send(fmt.Sprintf("dispatch movefocus %s", direction))
        case (direction == "r" || direction == "d") && addr == grouped[len(grouped)-1]:
            send(fmt.Sprintf("dispatch movefocus %s", direction))
        case direction == "l" || direction == "u":
            send("dispatch changegroupactive b")
        case direction == "r" || direction == "d":
            send("dispatch changegroupactive f")
        default:
            log.Printf("Unknown direction '%s'. Valid options are: l, r, u, d.", direction)
        }
    case "move":
        if len(grouped) == 0 {
            send(fmt.Sprintf("dispatch movewindoworgroup %s", direction))
			return
        }

		 switch {
        case (direction == "l" || direction == "u") && addr == grouped[0]:
            send(fmt.Sprintf("dispatch movewindoworgroup %s", direction))
        case (direction == "r" || direction == "d") && addr == grouped[len(grouped)-1]:
            send(fmt.Sprintf("dispatch movewindoworgroup %s", direction))
        case direction == "l" || direction == "u":
            send("dispatch movegroupwindow b")
        case direction == "r" || direction == "d":
            send("dispatch movegroupwindow f")
        default:
            log.Printf("Unknown direction '%s'. Valid options are: l, r, u, d.", direction)
        }
    default:
        fmt.Println("Invalid mode. Use 'focus' or 'move'.")
        os.Exit(1)
    }

}
