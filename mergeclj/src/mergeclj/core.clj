(ns mergeclj.core
  (:gen-class)
  (:import (java.util Date Timer Random)))

;;;
;;; MIMIC II individual level file merger

;; Each individual has files for all tables
;; If no entry, the file is empty
;; If there are entries, there is a header in the first row


;;; Function that given regexp return a function to
(defn file-seq-with
  "Given a regexp, return a function to return file-seq filtered by the regexp"
  [regexp]
  (fn [dir]
    (->> dir
         (clojure.java.io/file,  )
         (file-seq,  )
         ;; Filter by name
         (filter #(re-find regexp (.toString %)),  ))))


;;; Function to return the header
(defn file-header
  "Obtain the file header by getting the first line of a first valid file."
  [files-in]
  ;; Open the output file
  (->> (for [file-in files-in]
         ;; Work for each file
         (with-open [rdr (clojure.java.io/reader file-in)]
           ;; Obtain the first line of each file
           (str (first (line-seq rdr)))))

       ;; Drop empty ones
       (drop-while #(zero? (count %)),  )
       ;; Get the first valid one
       (first,  )
       (#(str % "\n"))))


;;; Function to write the header
(defn write-header
  "Write a header to a new file given a header string"
  [header file-out]
  (with-open [wtr (clojure.java.io/writer file-out)]
    (.write wtr (str header))))


;;; Read an individual file (leave
(defn read-files-write-content [files-in file-out]
  (with-open [wtr (clojure.java.io/writer file-out :append true)]

    ;; Work on each file
    (doseq [file-in files-in]

      ;; Open each file
      (with-open [rdr (clojure.java.io/reader file-in)]

        ;; write to the output file
        (doseq [line (rest (line-seq rdr))]
          (.write wtr (str line "\n")))))))


;;; Function to fix ICD9 file
(defn fix-broken-end-quotes
  "Fix end quotes located in the next line found in ICD9"
  [file-in file-out]
  (with-open [rdr (clojure.java.io/reader file-in)
              wtr (clojure.java.io/writer file-out)]
    (doseq [line (line-seq rdr)]

      ;; if not ending with " do not add "\n"
      (if (= (last line) \")
        (.write wtr (str line "\n"))
        (.write wtr (str line))))))


;;; Fucntion to expand a tilde in the path
(defn exp-tilde [path]
  (clojure.string/replace path "~" (System/getenv "HOME")))


;;; Main function to be run first

(defn -main
  "Read from individual files and merge into an output file"
  [& args]
  
  (do
    ;; Print start time
    (println (str "Started at \n" (str (new java.util.Date))))
    ;; Define constants in let    
    (let [regexps-str ["ADDITIVES"
                       "ADMISSIONS"
                       "A_CHARTDURATIONS"
                       "A_IODURATIONS"
                       "A_MEDDURATIONS"
                       "CENSUSEVENTS"
                       "CHARTEVENTS"
                       "COMORBIDITY_SCORES"
                       "DELIVERIES"
                       "DEMOGRAPHICEVENTS"
                       "DEMOGRAPHIC_DETAIL"
                       "DRGEVENTS"
                       "D_PATIENTS"
                       "ICD9"
                       "ICUSTAYEVENTS"
                       "ICUSTAY_DAYS"
                       "ICUSTAY_DETAIL"
                       "IOEVENTS"
                       "LABEVENTS"
                       "MEDEVENTS"
                       "MICROBIOLOGYEVENTS"
                       "NOTEEVENTS"
                       "POE_MED"
                       "POE_ORDER"
                       "PROCEDUREEVENTS"
                       "TOTALBALEVENTS"]
          ;;
          txt-regexp-str ".*\\.txt"
          path-in        (exp-tilde "~/mimic2/_raw_individual_files/")
          path-out       (exp-tilde "~/mimic2/_merged_files/")
          file-broken    "ICD9"]

      ;; Loop over regexps for side effects
      (doseq [regexp-str regexps-str]

        (let [file-names (->> ((file-seq-with (re-pattern (str regexp-str txt-regexp-str))) path-in)
                              ;; Limit to first X files
                              ;; (#(take 30 %))
                              )]
          ;;
          (do ; all the following

            ;; write header
            (write-header (file-header file-names) (str path-out regexp-str ".txt"))

            ;; write the remaining
            (read-files-write-content file-names   (str path-out regexp-str ".txt"))
            
            ;; Show status
            (println (str "Merging " regexp-str " Done!\n" (str (new java.util.Date)) "\n")))))

      ;; The ICD9 file are broken. Trailing " is located in the next line
      ;; May not worth the complicity
      (let [file-in  (str path-out file-broken ".txt")
            file-out (str path-out file-broken ".fixed.txt")]
        (fix-broken-end-quotes  file-in file-out)))
    
    ;; Print end time
    (println (str "Ended at \n" (str (new java.util.Date))))))
