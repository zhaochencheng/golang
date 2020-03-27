package main
import (
	//"biz"
	"context"
	"fmt"
	"go_test/golang/test2/src/biz"
	"net/http"
	"os"
	"os/signal"
	"syscall"
)
// gracefully exit http server
var done = make(chan bool, 1)      // 用于同步main线程和handleExitSignal线程
var quit = make(chan os.Signal, 1) // 用于接收信号量
func handleExitSignal(s *http.Server) {
	// 监听下面两个信号量
	signal.Notify(quit, syscall.SIGTERM) // kill
	signal.Notify(quit, syscall.SIGINT)  // ctrl + c
	// 阻塞等待信号量
	<-quit
	// 关闭server，引起ListenAndServe函数返回
	if err := s.Shutdown(context.Background()); err != nil {
		fmt.Printf("ShutDown Error: %v", err)
	}
	// 通知主线程handleExitSignal结束了
	close(done)
}
func serverHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte(biz.GetRandomPair()))
	w.Write([]byte(biz.GetRandomPair2()))
	w.Write([]byte("Hello,this is test!"))
	//w.Write([]byte(biz.GetRandomPair3()))
}
func runHttpServer() {
	http.HandleFunc("/randompair", serverHandler)
	server := &http.Server{Addr: ":9999", Handler: nil}
	go handleExitSignal(server)
	e := server.ListenAndServe()
	if e != nil {
		if http.ErrServerClosed == e {
			fmt.Println("server closed")
		} else {
			fmt.Println("server error")
			os.Exit(1)
		}
	}
	// 等待handleExitSignal完成
	<-done
}
func main() {
	fmt.Println("start server")
	runHttpServer()
	fmt.Println("stop server")
}