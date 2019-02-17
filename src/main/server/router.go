package server

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func Index(c *gin.Context) {
	c.String(http.StatusOK, "splash")
}

func Health(c *gin.Context) {
  c.String(http.StatusOK, "okay")
}

func NewRouter() *gin.Engine {
	router := gin.New()
	router.Use(gin.Logger())
	router.Use(gin.Recovery())

	router.GET("/_dev/health", Health)
	router.GET("/", Index)

	return router

}
