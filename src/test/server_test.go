package tests

import (
	"net/http"
	"net/http/httptest"

	"github.com/carlos-loya/hunt-dex/src/main/server"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("Server", func() {

	r := server.NewRouter()

	Context("Router", func() {
		It("Should return okay if the /_dev/health endpoint is requested.",func ()  {
			w := httptest.NewRecorder()
			req, _ := http.NewRequest("GET", "/_dev/health", nil)
			r.ServeHTTP(w, req)

			Expect(w.Code).To(Equal(http.StatusOK))
			Expect(w.Body.String()).To(Equal("okay"))

		})
  })
})
