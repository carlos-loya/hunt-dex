package tests

import (
  "testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestSuites(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Test Suites")
}
