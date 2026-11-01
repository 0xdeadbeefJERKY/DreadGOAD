package cmd

import (
	"os"
	"path/filepath"
	"reflect"
	"testing"
)

func TestExtensionInventories(t *testing.T) {
	dir := t.TempDir()
	runtime := filepath.Join(dir, "inventory")
	template := filepath.Join(dir, "inventory.j2")
	body := "[default]\ndc01 ansible_host=i-0123456789abcdef0\n\n" +
		"[wazuh_server]\nwazuh ansible_host=i-0fedcba9876543210 ansible_shell_type=sh\n"
	if err := os.WriteFile(runtime, []byte(body), 0o644); err != nil {
		t.Fatal(err)
	}

	tests := []struct {
		name     string
		runtime  string
		machines []string
		want     []string
	}{
		{"runtime defines every machine", runtime, []string{"wazuh"}, nil},
		{"machine missing from runtime", runtime, []string{"wazuh", "elk"}, []string{template}},
		{"no declared machines", runtime, nil, []string{template}},
		{"unreadable runtime inventory", filepath.Join(dir, "missing"), []string{"wazuh"}, []string{template}},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := extensionInventories(tt.runtime, template, tt.machines); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("extensionInventories() = %v, want %v", got, tt.want)
			}
		})
	}
}
