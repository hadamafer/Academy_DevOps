package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"os"
	"time"
	"strconv"
)

const PORT = ":9090"

type Resp struct {
	Status bool     `json:"status"`
	Fruits []string `json:"nros"`
}

type Resp2 struct {
	Status bool   `json:"status"`
	Msm    string `json:"message"`
}

func homePage(w http.ResponseWriter, r *http.Request) {
	html := `<h1>Calculadora API </h1>`
	w.Header().Set("Content-Type", "text/html")
	fmt.Fprint(w, html)
	fmt.Println("Endpoint Hit: homePage")
}

//-------------------Lee la Linea-----------------
func search(index int) int {
	readFile, err := os.Open("nros.txt")
	var res string
	var res_f int

	if err != nil {
		log.Fatal(err)
	}
	fileScanner := bufio.NewScanner(readFile)
	fileScanner.Split(bufio.ScanLines)
	c := 0
	for fileScanner.Scan() {
		if c == index {
			res = fileScanner.Text()
			res_f, _ = strconv.Atoi(res)
			break
		}
		c = c + 1
	}
	return res_f
}

//-----------------------GETNROS-----------------------
func getNros(w http.ResponseWriter, r *http.Request) {
	
	f := []string{""}
	var st string
	var rep []byte
	var err error
	// http://localhost:9090/nro?nro1=7&nro2=3&ope=sum
	queryS := r.URL.Query()
	nro1 := queryS.Get("nro1")
	nro2 := queryS.Get("nro2")
	operation := queryS.Get("ope")

	if nro1 != "" && nro2 != "" {
		a, _ := strconv.Atoi(nro1)
		b, _ := strconv.Atoi(nro2)
		line1 := search(a)
		line2 := search(b)

		result, error := calculator(operation, line1, line2)
		sresult := strconv.Itoa(result)
		sline1 := strconv.Itoa(line1)
		sline2 := strconv.Itoa(line2)
		if error == true {
			st = sline1 + " " + operation + " " + sline2 + " = " + sresult
		} else {
			st = "nros not valid"
			fmt.Println("Print in log fruit", st)
		}
		rep, err = tojsonr2(st)

		fmt.Println("Print in log fruit", st)
	} else {
		rep, err = json.Marshal(Resp{
			Status: true,
			Fruits: f,
		})
		if err != nil {
			log.Fatalf("Error happened in JSON marshal. Err: %s", err)
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	}
	w.Header().Set("Content-type", "Application/json")
	_, err = w.Write(rep)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusOK)
}

//-----------------------Calculator--------------------
func calculator(ope string, nro1 int, nro2 int) (int, bool) {
	var result int
	def := true

	switch ope {
	case "suma":
		result = nro1 + nro2
	case "res":
		result = nro1 - nro2
	case "div":
		result = nro1 / nro2
	case "mult":
		result = nro1 * nro2
	default:
		def = false
	}
	return result, def

}

//-----------------------Transforma a JSON-------------

func tojsonr2(st string) ([]byte, error) {
	res2, err := json.Marshal(Resp2{
		Status: true,
		Msm:    st,
	})
	return res2, err

}
//-----------------------------------------------------------------------------------------------------------------
//--------------------------------------------------FILEMANAGER----------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------
const DATA_FILE = "nros.txt"
const nums = 4096

func numramd(min int, max int) int {
	rand.Seed(time.Now().UnixNano())
	val := rand.Intn(max) - min
	return val
}
func createFile() {
	fmt.Printf("Writing to a file in Go lang\n")
	file, err := os.Create(DATA_FILE)
	if err != nil {
		log.Fatalf("failed creating file: %s", err)
	}
	defer file.Close()

	w := bufio.NewWriter(file)
	for i := 0; i <= nums; i++ {
		rnumber := numramd(-nums, nums)
		w.WriteString(fmt.Sprint(rnumber) + "\n")
	}
	defer w.Flush()
}
func readline(ln int) string {
	f, _ := os.Open(DATA_FILE)
	defer f.Close()
	sc := bufio.NewScanner(f)
	lastLine := 0
	var line string
	for sc.Scan() {
		if lastLine++; lastLine == ln {
			line = sc.Text()
			break
		}
	}
	if line == "" {
		line = "0"
	}
	return line
}
//----------------------------------------------------------------------------------------------------------------------------

//-----------------------MAIN-------------
func main() {
	createFile()
	http.HandleFunc("/nro", getNros)
	http.HandleFunc("/", homePage)

	log.Println("Starting web server on Port", PORT)
	log.Fatal(http.ListenAndServe(PORT, nil))
}
