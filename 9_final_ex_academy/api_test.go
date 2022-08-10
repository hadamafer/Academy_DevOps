package main

import(
    "net/http"
    "testing"
)

func TestSum(t *testing.T) {
    total,_ := calculator("suma", 1, 1)
    if total != 2 {
       t.Errorf("Sum was incorrect, got: %d, want: %d.", total, 2)
    }
}

func TestFetchGophers(t *testing.T) {
	_, err := http.NewRequest("GET", "/nro", nil)
	if err != nil {
		t.Fatalf("could not created request: %v", err)
	}
}