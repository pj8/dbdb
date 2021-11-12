/*
Copyright © 2021 NAME HERE <EMAIL ADDRESS>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package cmd

import (
	"bytes"
	"fmt"
	"os/exec"
	"strings"

	"github.com/spf13/cobra"
)

var createFlags struct {
	name    string
	version string
	port    string
}

// createCmd represents the create command
var createCmd = &cobra.Command{
	Use:   "create",
	Short: "create database command",
	Long:  "create database command",
	Run: func(cmd *cobra.Command, args []string) {
		createDbServer(args[0], createFlags.name, createFlags.version, createFlags.port)
	},
}

func createDbServer(arg string, name string, version string, port string) {
	path := "./" + strings.ToLower(arg) + "/create.sh"
	cmd := exec.Command(path, name, version, port)
	var stdout bytes.Buffer
	var stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	err := cmd.Run()
	if err != nil {
		fmt.Printf("Stdout: %s\n", stdout.String())
		fmt.Printf("Stderr: %s\n", stderr.String())
	} else {
		fmt.Printf("Stdout: %s\n", stdout.String())
		fmt.Printf("%s server created as %s @PORT:%s", arg, name, port)
	}
}

func init() {
	rootCmd.AddCommand(createCmd)
	rootCmd.PersistentFlags().StringVarP(&createFlags.name, "name", "", "", "DB Server Name")
	rootCmd.PersistentFlags().StringVarP(&createFlags.version, "version", "v", "", "DB Server Version")
	rootCmd.PersistentFlags().StringVarP(&createFlags.port, "port", "p", "", "DB Server Port")

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// createCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// createCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
