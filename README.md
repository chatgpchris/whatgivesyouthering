# What Gives You the Ring? 🏀 A basic analysis of NBA Champions’ stats from 2012-13 to 2023-24

**Author:** Christos Georgakakis  
**Date:** August 2025  
**Dataset Source:** freely available data uploaded by NocturneBear on Github https://github.com/NocturneBear/NBA-Data-2010-2024

---

## 📌 Research Questions
- What were the champions’ average stats in the playoffs from 2012-13 to 2023-24 ?
- What were the champions’ ranks with respect to each stat type in the playoffs from 2012-13 to 2023-24?
- How many times were champions ranked 1st or at least 2nd or at least 3rd, by stat type, in the playoffs from 2012-13 to 2023-24?   
- Were the champions’ offensive average stat ranks better than the defensive ones in the playoffs from 2012-13 to 2023-24?
- What were the champions’ average stats in the regular season from 2012-13 to 2023-24 ?
- What were the champions’ ranks with respect to each stat type in the regular season from 2012-13 to 2023-24?
- How many times were champions ranked 1st or at least 2nd or at least 3rd, by stat type, in the regular season from 2012-13 to 2023-24?  
- Were the champions’ offensive average stat ranks better than the defensive ones in the regular season from 2012-13 to 2023-24?
- How did the champions’ stats in the regular season differ from their playoffs stats from 2012-13 to 2023-24?
- Are there any basic insights emerging from these questions ?


---

## 🛠️ Methodology and tools used
1. Importing multiple CSV tables (regular season totals, playoffs totals, and per-game stats) into MySQL.
2. Using SQL queries and the MySQL interface to clean, process and analyze the data.
3. Exporting data to spreadsheets and reimporting them to MySQL or Google Sheets.
4. Using Google Sheets for data cleaning and processing, and for creating visualizations
5. Employing Tableu Public for specific visualizations
6. Creating the final presentation using Google Slides
7. Creating the current readme md file in Github


---

## 📊 Key Findings
- **2-Point FG%**: Champions ranked in the top 3 spots 10 out of 12 times in playoffs and 9 out of 12 times in regular seasons.
- **Assists**: Often high-ranked, indicating efficient ball movement is common among champions.
- Average differences between regular season and playoff stats for champions were **minimal**.
- The champions’ average attack stats ranks were slightly but not significantly better than the average defense stats ranks both in the playoffs and in the regular season
- See the repository files for more details, as well as corresponding insights.

---

## 📂 Files in this Repository
- **`nba_project.sql`** — SQL code for full data cleaning, preparation, and analysis. *(Warning: destructive commands included — drops and deletes!)*
- **`What gives you the ring.pptx`** — Presentation slides including: the research questions, the methodology, the analysis results, key findings, insights, and avenues for further research.
- **`What gives you the ring.pdf`** — PDF version of the slides for quick viewing.
- **`README.md`** — This file, describing the project.

---

## ⚠️ Notes
- This SQL script is **destructive** — it includes `DROP DATABASE` and `DELETE` commands.
- Designed for MySQL (tested on MySQL 8.0).  
- Seasons 2010–11 and 2011–12 removed due to missing regular season data.

---

## 📈 Possible Future Improvements
- Collect data from previous seasons and see whether the insights and findings about the last 12 seasons are confirmed or falsified by the expanded dataset.
- Check whether there are any (groups of) playoffs stats that sufficiently together ensure getting the ring, and with respect to which champions outperform the other title contenders.
- Experimenting with removing from the analysis seasons where the champions were ranked high with respect to many stat types, or seasons where the champions were not ranked high in many stat types.  


---

## 📬 Contact
For any questions or comments, feel free to reach out: *chatgpchris@gmail.com*
