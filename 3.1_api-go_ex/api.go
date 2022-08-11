package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"bufio"
	"os"
	"math"
)


const PORT = ":8080"

type Resp struct {
	Status bool     `json:"status"`
	Fruits []string `json:"fruits"`
}

type Resp2 struct {
	Status bool   `json:"status"`
	Msm    string `json:"message"`
}

func homePage(w http.ResponseWriter, r *http.Request) {
	html := `<strong>hola fer </strong>`
	w.Header().Set("Content-Type", "text/html")
	fmt.Fprint(w, html)
	fmt.Println("Endpoint Hit: homePage")
}

func tojsonr2(st string) ([]byte, error) {
	res2, err := json.Marshal(Resp2{
		Status: true,
		Msm:    st,
	})
	return res2, err

}
func search(index int) float64 {
    readFile, err := os.Open("data.txt")
	var res string 
	var res_f float64

    if err != nil {
            log.Fatal(err)
    }
    fileScanner := bufio.NewScanner(readFile)
    fileScanner.Split(bufio.ScanLines)
    c := 0 
    for fileScanner.Scan(){
        if c == index{
            res = fileScanner.Text()
			res_f,_ = strconv.ParseFloat(res,64) // pasar de string a float

			break
		}
        c=c+1
    }
	return res_f
}

func operator(operador string, num1 float64, num2 float64) (float64 , bool){
	var res float64
	var err bool
	err = true

	switch operador {
	case "suma":
		res= num1 + num2
	case "resta":
		res = num1 - num2
	case "div":
		res= num1 / num2
	case "mult":
		res = num1 * num2
	case "mod":
		res = math.Mod(num1, num2)
	default:
		err = false			
	}
	return res,err
}

func operation(w http.ResponseWriter, r *http.Request){
	query := r.URL.Query() // http://localhost:8080/op?num=7&num2=3&op=suma
	num := query.Get("num")
	num2:= query.Get("num2")
	oper:=query.Get("op")	
	var st string 
	var rep []byte
	var err error //no entendi muy bien como tratarlo -> VER
	var flag bool
	var res float64

	if num2 != "" && num!="" {
		a, _ := strconv.Atoi(num)
		num_a:=search(a)

		a2, _ := strconv.Atoi(num2)
		num_a2:=search(a2)

		res,flag = operator(oper,num_a, num_a2)

		if flag == true{
			res_s := strconv.FormatFloat(res , 'f' , 5 , 64)
			num_as := strconv.FormatFloat(num_a , 'f' , 5 , 64)
			num_a2s := strconv.FormatFloat(num_a2 , 'f' , 5 , 64)

			st = num_as + " " + oper + " " +  num_a2s + " = " + res_s
			rep, err = tojsonr2(st)

			fmt.Println("Print numeros", st)
		} 		
		
	} else {
		rep, err = json.Marshal(Resp{
			Status: true,
		})
		if err != nil {
			log.Fatalf("Error happened in JSON marshal. Err: %s", err)
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	}

	w.Header().Set("Content-type", "Application/json")
	_, err = w.Write(rep)
	if err != nil  || flag == false {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}

func main() {
	http.HandleFunc("/op", operation)
	http.HandleFunc("/", homePage)

	log.Println("Starting web server on Port", PORT)
	log.Fatal(http.ListenAndServe(PORT, nil))
}