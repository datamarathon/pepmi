(ns extractclj.core
  (:gen-class))



;;; Function to return a string-to-seq function with predefined regexp
(defn string-to-seq-with
  "Return a string by dividing str-in with sep-regexp"
  [sep-regexp]
  (fn [str-in] (clojure.string/split str-in sep-regexp)))

((string-to-seq-with #",") "SUBJECT_ID,ICUSTAY_ID,ITEMID")


;;; Function to convert a line in a string to a seq using , as separator
(def string-to-seq (string-to-seq-with #","))

(string-to-seq "SUBJECT_ID,ICUSTAY_ID,ITEMID")


;;; Function to detect which columns are for SUBJECT_ID,ICUSTAY_ID,ITEMID
(defn which
  "Return which element in a seq is a match. 0-based"
  [seq-in match-str]
  (->> (keep-indexed #(if (= %2 match-str) %1) seq-in)
       first))

(which (string-to-seq "SUBJECT_ID,ICUSTAY_ID,ITEMID") "SUBJECT_ID")
(which (string-to-seq "SUBJECT_ID,ICUSTAY_ID,ITEMID") "ITEMID")


;;; Filter function to filter by IDs
(defn id-match?
  "Given a line as a string, divide it up by , and check for pt-ids(set), and check for item-ids(set)"
  ;; arity 5
  ([line-as-seq item-ids item-id-index pt-ids pt-id-index]
     (let [item-id (nth line-as-seq item-id-index)
           pt-id   (nth line-as-seq pt-id-index  )]
       ;;
       (and (contains? item-ids item-id)
            (contains? pt-ids   pt-id))))
  ;; arity 3
  ([line-as-seq item-ids item-id-index]
     (let [item-id (nth line-as-seq item-id-index)]
       ;;
       (contains? item-ids item-id))))

(id-match? (string-to-seq "1,2,3,4") #{"1","2","3"} 1)
(id-match? (string-to-seq "1,2,3,4") #{"1","3"} 1)


;;; Function to conditionally write to the file-out
(defn write-if-match
  "Write to file-out if a line from file-in matches to IDs given "
  ;; arity 6: item ID and patient ID
  ([file-in file-out item-ids item-id-name pt-ids pt-id-name]
     (with-open [rdr (clojure.java.io/reader file-in)
                 wtr (clojure.java.io/writer file-out)]

       (let [header-line   (first (line-seq rdr))
             header-seq    (string-to-seq header-line)
             item-id-index (which header-seq item-id-name)
             pt-id-index   (which header-seq pt-id-name)]

         ;; Write the header first
         (.write wtr (str header-line "\n"))

         ;; Read line by line from lines where IDs match
         (doseq [line (filter #(id-match? (string-to-seq %)
                                          item-ids item-id-index
                                          pt-ids pt-id-index)
                              (line-seq rdr))]
           ;; write
           (.write wtr (str line "\n"))))))

  ;;
  ;; arity 4: item ID only
  ([file-in file-out item-ids item-id-name]
     (with-open [rdr (clojure.java.io/reader file-in)
                 wtr (clojure.java.io/writer file-out)]

       (let [header-line   (first (line-seq rdr))
             header-seq    (string-to-seq header-line)
             item-id-index (which header-seq item-id-name)]

         ;; Write the header first
         (.write wtr (str header-line "\n"))

         ;; Read line by line from lines where IDs match
         (doseq [line (filter #(id-match? (string-to-seq %)
                                          item-ids item-id-index)
                              (line-seq rdr))]
           ;; write
           (.write wtr (str line "\n")))))))


;;; Define a fucntion to expand a tilde in the path to the home
(defn exp-tilde [path]
  (clojure.string/replace path "~" (System/getenv "HOME")))


;;; Actual filtering


;;; Define the main function to be run from lein
(defn -main
  "I don't do a whole lot ... yet."
  [& args]

  (let [file-in (exp-tilde "~/mimic2/_merged_files/CHARTEVENTS.txt")

        id-age-gr-60 (->> "~/mimic2/_filtered_files/ICUSTAY_ID_Age_gr_60.txt"
                          (exp-tilde)
                          (slurp)
                          ((string-to-seq-with #"\n"))
                          (rest)
                          (set))  
        ]


    ;; ;; Ventilator: [505,506,535,543,544,545,619, 39,535,683,720,721,722,732]
    ;; (write-if-match file-in
    ;;                 (exp-tilde "~/mimic2/_filtered_files/CHARTEVENTS_Vent.txt")

    ;;                 (set (map str (range 1 31)))
    ;;                 "SUBJECT_ID"
    ;;                 (set (map str [505,506,535,543,544,545,619, 39,535,683,720,721,722,732]))
    ;;                 "ITEMID")

    ;; ;; SpO2: [1148,646,834]
    ;; (write-if-match file-in
    ;;                 (exp-tilde "~/mimic2/_filtered_files/CHARTEVENTS_SpO2_sub15-30.txt")

    ;;                 (set (map str (range 15 31)))
    ;;                 "SUBJECT_ID"
    ;;                 (set (map str [1148,646,834]))
    ;;                 "ITEMID")

    ;; (write-if-match file-in
    ;;                 (exp-tilde "~/mimic2/_filtered_files/CHARTEVENTS_SpO2.txt")

    ;;                 (set (map str [1148,646,834]))
    ;;                 "ITEMID")

    ;; ITEMID  LABEL      CATEGORY
    ;; ---------------------------
    ;;   614	Resp Rate (Spont)
    ;;   615	Resp Rate (Total)
    ;;   618	Respiratory Rate  (*)
    ;;   653	Spont. Resp. Rate
    ;;   1151	Respiratory Rate:
    ;;   1635	HIGH Resp Rate
    ;;   1884	Spont Resp rate
    ;;   2117	Low resp rate
    ;;   3603	Resp Rate
    ;;   3337	Breath Rate
    (write-if-match file-in
                    (exp-tilde "~/mimic2/_filtered_files/CHARTEVENTS_RR.txt")

                    ;; Age restriction
                    id-age-gr-60
                    "ICUSTAY_ID"

                    ;; Recommended RR item
                    (set (map str [618]))
                    "ITEMID")


    ;; ;; Create a unique one
    ;; (with-open [rdr (clojure.java.io/reader (exp-tilde "~/mimic2/_filtered_files/CHARTEVENTS_RR.txt"))
    ;;             wtr (clojure.java.io/writer (exp-tilde "~/mimic2/_filtered_files/CHARTEVENTS_RR2.txt"))]
    ;;   (doseq [line (line-seq rdr)]
    ;;     (.write wtr (str line "\n"))))
    
    (println "Done!")))
