; Define a patch feature
patches-own [
  ; The patch has a type
  patchesType
]

; Defines the species existing in the program
breed [
  ; species person
  peoples people
]

; Defines the characteristics withmon to turtles
turtles-own [
  ; Turtle movement speed
  steps
]

; Defines the specific characteristics of the people species
peoples-own [

  ; Agent's age
  ageAgent

  ; Is the agent infected?
  diagnosticAgent

  ; Agent gender
  sexAgent

  ; Is the agent wearing a mask?
  maskAgent

  ; Is the agent in isolation?
  isolationAgent

  ; Is the agent in treatment?
  treatment

  ; Is the agent dead?
  dead

  ; Is the agent cured?
  cured

  ; Counter, in ticks, of the time the agent is in treatment
  timeTreatment

  ; Counter, in ticks, of the time the agent is infected but nott in treatment
  timeTreatmentGo

]

; Global variable
globals [countTicks saveData]

; Configures the yesulation
to setup

  ; Clear the map
  clear-all

  ; Configure the world
  setup_world

  ; Reset ticks (time)
  reset-ticks

  ; Open the file
  open_file
end

; Open the file
to open_file

  ; Saves data to a txt file
  set saveData "saveData.txt"

  ; Checks if the file already exists, then delete it
  if (file-exists? saveData) [file-close file-delete saveData]

  ; Opens a new file
  file-open saveData
end

; Configures the mini world
to setup_world

  ; Changes all patches to gray
  ask patches [set pcolor gray]

  ; Creates the top wall
  ask patches with [pycor = 12 and (pxcor >= -16 and pxcor <= -3)] [set pcolor black]
  ask patches with [pycor = 12 and (pxcor <= 16 and pxcor >= 3)] [set pcolor black]

  ; Creates the bottom wall
  ask patches with [pycor = -12 and (pxcor >= -16 and pxcor <= -3)] [set pcolor black]
  ask patches with [pycor =  -12 and (pxcor <= 16 and pxcor >= 3)] [set pcolor black]

  ; Creates the left wall
  ask patches with [pxcor = -12 and (pycor >= -12 and pycor <= -7)] [set pcolor black]
  ask patches with [pxcor = -12 and (pycor <= 12 and pycor >= 7)] [set pcolor black]
  ask patches with [pxcor = -12 and (pycor <= 1 and pycor >= -1)] [set pcolor black]
  ask patches with  [pycor = 0 and (pxcor <= -12 and pxcor >= -16)] [set pcolor black]

  ; Symbolic colors for the areas

  ; Upper area, treatment
  ask patches with [pycor = 15 and pxcor = 5] [set pcolor red]

  ;  Lower area, insulation
  ask patches with [pycor = -15 and pxcor = 5] [set pcolor blue]

  ; Left side area, cured
  ask patches with [pycor = 4 and pxcor = -11] [set pcolor green]

  ; Left lateral area, deaths
  ask patches with [pycor = -4 and pxcor = -12] [set pcolor brown]

  ; Defines that the entire patch with the black color will be called "wall"
  ask patches with [pcolor = black] [set patchesType "muro"]

  ; Starts the global variable, which counts the number of ticks given, with zero
  set countTicks 0

end

; Configure agents
to setup_agents

  ; Create the turtles based on the characteristics chosen by the observer
  create-peoples quantity [

    ; Set the age characteristic (elderly or young) of the turtle according to which the researcher chose
    set ageAgent age

    ; Set the diagnostic characteristic (infected or nott) according to which the researcher chose
    set diagnosticAgent diagnostic

    ; Set the gender characteristic (male or female) according to which the researcher chose
    set sexAgent sex

    ; Set the characteristic mask (with or without) according to what the researcher has chosen
    set maskAgent mask

    ; Set the isolation characteristic (yes or not) according to which the researcher has chosen
    set isolationAgent isolation

    ; Starts the timeTreatment variable with 0
    set timeTreatment 0

    ; Starts the timeTreatmentGo variable with 0
    set timeTreatmentGo 0

    ; Starts the treatment variable with "not"
    set treatment "not"

    ; Starts the dead variable with "not"
    set dead "not"

    ; Starts the cured variable with "not"
    set cured "not"

    ; Calls the procedure that changes the shape based on the age of the agent
    set_age

    ; Calls the procedure that changes the color of the agent based on the diagnotsis
    set_diagnostic

    ; Calls the procedure that sets the agent's initial position
    set_position

    ; Calls the preocedure that sets the agent's speed based on age
    setVelocity

    ; Change the size of the turtle
    set size 2

    ; Changes the angle of the turtle head to a random value
    set heading random 360

  ]
end

; Changes the shape based on the age of the agent
to set_age

  ; If the agent is elderly
  ifelse (age = "old") [

    ; If the agent is male
    ifelse (sex = "male") [

      ; If the agent wears a mask
      ifelse (mask = "with") [

        ; Changes the shape of the agent to elderly male with mask
        set shape "person old protect"

      ]

      ; If nott, the agent does nott use a mask
      [
        ; Changes the shape of the agent to elderly male without a mask
        set shape "person old"

      ]

    ]

    ; If nott, the agent is female
    [

      ; If the agent wears a mask
      ifelse (mask = "with") [

        ; Changes the shape of the agent to elderly female with mask
        set shape "person old female protect"

      ]

      ; If nott, the agent does nott use a mask
      [

        ; Changes the shape of the agent to elderly female without a mask
        set shape "person old female"

      ]

    ]

  ]

  ; If nott, the agent is young
  [

    ; If the agent is male
    ifelse (sex = "male") [

      ; If the agent wears a mask
      ifelse (mask = "with") [

        ; Changes the shape of the agent to a young male with a mask
        set shape "person man protect"

      ]

      ; If nott, the agent does nott use a mask
      [

        ; Changes the shape of the agent to a young male without a mask
        set shape "person man"

      ]

    ]

    ; If nott, the agent is female
    [

      ; If the agent wears a mask
      ifelse (mask = "with") [

        ; Changes the shape of the agent to young female with mask
        set shape "person female protect"

      ]

      ; If nott, the agent does nott use a mask
      [
        ; Changes the shape of the agent to young female without a mask
        set shape "person female"

      ]

    ]

  ]

end

; Changes the color of the agent based on the diagnotsis
to set_diagnostic

  ; If the agent is infected
  ifelse (diagnostic = "infected") [

    ; Changes the agent's color to red
    set color red

  ]

  ; If nott, the agent is nott infected
  [

    ; Changes the agent's color to black
    set color black

  ]

end

; Sets the starting position of the agent
to set_position

  ; If the agent is in isolation
  ifelse (isolation = "yes") [

    ; Draw a value for the x coordinate
    let x_cor random 32

    ; If the amount drawn is greater than 16
    if (x_cor > 16) [

      ; Changes the drawn value to the negative x coordinate
      set x_cor (x_cor - 16) * (-1)

    ]

    ; Changes the x coordinate of the agent
    set xcor x_cor

    ; Variable y_cor starts with 2
    let y_cor 2

    ; Subtract 16 from y_cor
    set y_cor y_cor - 16

    ; Changes the y coordinate of the agent
    set ycor y_cor

  ]

  ; Positions the agent outside the isolation and fields of cure, death and treatment
  [
    let x_cor random 25

    if (x_cor > 15) [set x_cor (x_cor - 15) * (-1)]

    set xcor x_cor


    let y_cor random 21

    if (y_cor > 10) [set y_cor (y_cor - 10) * (-1)]

    set ycor y_cor

    ]

end

; Sets the agent's speed based on age
to setVelocity

  ; If the agent is elderly
  ifelse (age = "old") [

    ; Change speed to 0.1
    set steps 0.1

  ]

  ; If nott, the agent is young
  [

    ; Change speed to 1
    set steps 1

  ]

end

; Starts the function that configures the agents
to create_turtle

  ; Calls the procedure that configures the agents
  setup_agents

end

; Initial function
to go

  ; Increment the tick
  tick

  ; Increment the tick counter
  set countTicks countTicks + 1

  ; Moves agents to the area of ​​cure or death if they fit the condition
  move_die_real

  ; Scans each infected agent allowing it to infect uninfected agents
  check_infected

  ; Ask people
  ask peoples [

    ; If the agent is nott dead
    if (dead = "not")[

      ; move on
      move

    ]

    ; If the agent is in treatment and is less than 1000 ticks in that situation
    if (treatment = "yes" and timeTreatment <= 1344) [

      ; Increase the treatment time counter
      set timeTreatment timeTreatment + 1

    ]

    ; If the agent is nott in treatment and is less than 1000 ticks in that situation
    if (treatment = "not" and timeTreatmentGo <= 336 and diagnosticAgent = "infected") [

      ; Increase the treatment time counter
      set timeTreatmentGo timeTreatmentGo + 1

    ]

  ]

  ; Analyzes the time the agent is infected and moves it to the treatment area if it fits the condition
  check_timeTreatment

  ; Terminates the yesulation if there is not live agent
  stopSimulation

  if (saveInFile? = true) [memoryData]

end

; Agent movement
to move

  ; Every 100 ticks
  if (countTicks = 100) [

    ; Changes the angle of the agent's head
    set heading random 360

    ; Reset the tick counter
    set countTicks 0

  ]

  ; If the agent is in the area of ​​death or cure
  if (cured = "yes" or dead = "yes") [

    ; While
    while[

      ; The Patch Type at two distance patches is of the "wall" type or
      [patchesType] of patch-ahead 2 = "muro" or

      ; The x coordinate of the patch at a distance patch is -12 or
      [pxcor] of patch-ahead 1 = -12 or

      ; The x coordinate of the patch at a distance patch is -16 or
      [pxcor] of patch-ahead 1 = -16 or

      ; The y coordinate of the patch at a distance patch is 12
      [pycor] of patch-ahead 1 = 12 or

      ; The y coordinate of the patch at a distance patch is 0
      [pycor] of patch-ahead 1 = 0

    ]

    ; Changes the angle of the agent's head
    [set heading random 360]

  ]

  ; If the agent is nott in isolation or treatment and is nott cured or dead (he is in the central area)
  if (isolationAgent = "not" and treatment = "not" and cured = "not" and dead = "not") [

    ; While...
    while [

      ; The Patch Type at two distance patches is of the "wall" type or
      [patchesType] of patch-ahead 2 = "muro" or

      ; The x coordinate of the patch at a distance patch is -11 or
      [pxcor] of patch-ahead 1 = -11 or

      ; The x coordinate of the patch at a distance patch is 16 or
      [pxcor] of patch-ahead 1 = 16 or

      ; The y coordinate of the patch at a distance patch is 11 or
      [pycor] of patch-ahead 1 = 11 or

      ; The y coordinate of the patch at a distance patch is -11
      [pycor] of patch-ahead 1 = -11

    ]

    [

      ; Changes the angle of the agent's head
      set heading random 360

    ]

  ]

  ; If the agent is in isolation or under treatment
  if (isolationAgent = "yes" or treatment = "yes") [

    ; While...
    while [

      ; The Patch Type at two distance patches is of the "wall" type or
      [patchesType] of patch-ahead 2 = "muro" or

      ; The y coordinate of the patch at a distance patch is 13 or
      [pycor] of patch-ahead 1 = 13 or

      ; The y coordinate of the patch at a distance patch is 16 or
      [pycor] of patch-ahead 1 = 16 or

      ; The x coordinate of the patch at a distance patch is 16 or
      [pxcor] of patch-ahead 1 = 16 or

      ; The x coordinate of the patch at a distance patch is -16 or
      [pxcor] of patch-ahead 1 = -16 or

      ; The y coordinate of the patch at a distance patch is -12 or
      [pycor] of patch-ahead 1 = -13 or

      ; The y coordinate of the patch at a distance patch is -16
      [pycor] of patch-ahead 1 = -16

    ]

    [

      ; Changes the angle of the agent's head
      set heading random 360

    ]

  ]

  ; Walk the number of steps specified by the steps variable
  fd steps

end

; Interaction between infected and uninfected agents
to check_infected

; Ask people who are infected
  ask peoples with [diagnosticAgent = "infected"] [

    if (maskAgent = "with") [

      ; Ask people in a 90-degree angle of view who are nott infected
      ask peoples in-cone 1 90 with [diagnosticAgent = "notInfected"] [

        ; If the agent wears a mask
        if (maskAgent = "with") [

          ; Draw the chance to get infected
          let random_infected random 100

          ; Masked agents have a 3 percent chance of bewithing infected
          if (random_infected < 3) [

            ; Changes color to red
            set color red

            ; Changes the diagnotsis
            set diagnosticAgent "infected"

          ]
        ]

        ; If the agent does nott use a mask
        if (maskAgent = "without") [

          ; Draw the chance to get infected
          let random_infected random 100

          ; Unmasked agents have a 60 percent chance of bewithing infected
          if (random_infected < 60) [

            ; Changes color to red
            set color red

            ; Changes the diagnotsis
            set diagnosticAgent "infected"
          ]
        ]
      ]
    ]

    if (maskAgent = "without") [
      ; Ask people in a 90-degree angle of view who are nott infected
      ask peoples in-cone 1 90 with [diagnosticAgent = "notInfected"] [

        ; If the agent wears a mask
        if (maskAgent = "with") [

          ; Draw the chance to get infected
          let random_infected random 100

          ; Masked agents have a 10 percent chance of bewithing infected
          if (random_infected < 10) [

            ; Changes color to red
            set color red

            ; Changes the diagnotsis
            set diagnosticAgent "infected"

          ]
        ]

        ; If the agent does nott use a mask
        if (maskAgent = "without") [

          ; Draw the chance to get infected
          let random_infected random 100

          ; Unmasked agents have a 90 percent chance of bewithing infected
          if (random_infected < 90) [

            ; Changes color to red
            set color red

            ; Changes the diagnotsis
            set diagnosticAgent "infected"
          ]
        ]
      ]
    ]
  ]
end

; Moves the agent to the area of cure or death by changing its characteristics. 336h(14d) - 1,344h(56d) to recover or die
to move_die_real

  ; If the turtle is being treated
  ask peoples with [treatment = "yes"] [
    let random_check random 1344

    if (random_check < 336) [set random_check random_check + 336]

    ; If it makes 1000 ticks that the turtle is being treated
    if (timeTreatment = random_check or timeTreatment = 1344) [

      ; Chance of death
      let random_die random 100

      ; If the turtle is an elderly person
      if (age = "old") [

        ; If the chance of death is less than 60
        ifelse (random_die <= 60) [

          ; Changes the characteristic of the "dead" agent to "yes"
          set dead "yes"

        ] [

         ; Changes the characteristic of the "cured" agent to "yes"
         set cured "yes"

        ]
      ]

      ; If the turtle is young
      if (age = "young") [

        ; If the chance of death is less than 30
        ifelse (random_die <= 30) [

          ; Changes the characteristic of the "dead" agent to "yes"
          set dead "yes"

        ] [

          ; Changes the characteristic of the "cured" agent to "yes"
          set cured "yes"

        ]
      ]

      ; Changes the agent's characteristic
      set treatment "not"

      ; Changes the agent's characteristic
      set diagnosticAgent "notInfected"

      ; If the agent has been marked as "dead" it makes changes to its characteristics and position
      if (dead = "yes") [

        ; Draw an x ​​coordinate within the death space
        let x_cor ((random 2) + 14) * -1

        ; Draw a y coordinate within the death space
        let y_cor ((random 9) + 2) * -1


        ; Moves the turtle to a random death area
        move-to patch x_cor y_cor

        ; Changes the angle of the agent's head so that the coffin is "standing"
        set heading 360

        ; Changes the agent's characteristic
        set dead "yes"

        ; Changes the figure of the agent
        set shape "rip"

    ]
      ; If the agent has been marked as "cured" it makes changes to its characteristics and position
      if( cured = "yes" )[

        ; Moves the turtle to the cured area
        move-to patch -14 5

        ; Changes the agent's characteristic
        set cured "yes"

        ; Change the agent's color
        set color black

      ]

    ]

  ]

end

; 48h - 336h (2d - 14d) to go to isolation
to check_timeTreatment

  ; Ask people
  ask peoples[
    let random_check random 336

    if (random_check < 48) [set random_check random_check + 48]

    ; If the treatment verification time is 1000 and the agent is infected
    if (diagnosticAgent = "infected" and (timeTreatmentGo = random_check or timeTreatmentGo = 336)) [

      ; Generates a random x coordinate within the possible area
      let x_cor random 33

      ; if the amount drawn is greater than 16
      if (x_cor > 16) [

        ; Changes the value to negative
        set x_cor (x_cor - 16) * (-1)

      ]

      ; Generates a random y coordinate within the possible area
      let y_cor (random 1) + 14

      ; Moves the turtle to a random point in the treatment area
      move-to patch x_cor y_cor

      ; Change the treatment variable to "yes"
      set treatment "yes"
    ]

  ]

end

to memoryData
  file-print (word
              "Number of ticks: " ticks
              "\nNumber of people infected: " count peoples with [diagnosticAgent = "infected"]
              "\nNumber of not-infected: " count peoples with [ diagnosticAgent = "notInfected" and dead = "not"]
              "\nPeople in isolation: " count peoples with [isolationAgent = "yes"]
              "\nPeople under treatment: " count peoples with[ treatment = "yes"]
              "\nHealed people: " count peoples with[ cured = "yes"]
              "\nDeaths: " count peoples with [ dead = "yes" ]
              "\nLiving people" count peoples with [ dead = "not"] "\n\n")
end

; Ends the yesulation
to stopSimulation

  ; If there is not turtle, the yesulation ends
  if not any? turtles [ stop ]

end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
56
22
119
55
NIL
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

TEXTBOX
386
22
481
66
Tratamento
18
9.9
1

TEXTBOX
386
413
483
435
Isolamento
18
9.9
1

TEXTBOX
212
166
277
191
Curados
18
9.9
1

TEXTBOX
214
269
272
291
Óbitos
18
9.9
1

CHOOSER
30
222
168
267
age
age
"old" "young"
1

CHOOSER
30
274
168
319
mask
mask
"with" "without"
1

CHOOSER
30
326
168
371
sex
sex
"male" "feminine"
0

SLIDER
15
377
187
410
quantity
quantity
1
10
10.0
1
1
NIL
HORIZONTAL

BUTTON
37
419
141
452
NIL
create_turtle
NIL
1
T
OBSERVER
NIL
C
NIL
NIL
1

BUTTON
56
59
119
92
NIL
go
T
1
T
OBSERVER
NIL
G
NIL
NIL
1

CHOOSER
29
118
167
163
diagnostic
diagnostic
"infected" "notInfected"
1

CHOOSER
29
170
167
215
isolation
isolation
"yes" "not"
1

PLOT
671
16
1001
166
Number of people infected
ticks
quantity
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Infected" 1.0 0 -5298144 true "" "plot count peoples with [diagnosticAgent = \"infected\"]"
"Not infected" 1.0 0 -16514302 true "" "plot count peoples with [diagnosticAgent = \"notInfected\"]"

MONITOR
701
177
824
222
Number of  infected
count peoples with [diagnosticAgent = \"infected\"]
17
1
11

MONITOR
837
178
974
223
Número de não infectados
count peoples with [ diagnosticAgent = \"notInfected\" and dead = \"not\" ]
17
1
11

MONITOR
699
233
823
278
People in isolation
count peoples with [isolationAgent = \"yes\"]
17
1
11

MONITOR
836
235
980
280
People under treatment
count peoples with[ treatment = \"yes\" ]
17
1
11

MONITOR
698
292
824
337
Healed people
count peoples with[ cured = \"yes\"]
17
1
11

MONITOR
834
294
977
339
Deaths
count peoples with [ dead = \"yes\" ]
17
1
11

MONITOR
698
345
826
390
Living people
count peoples with [ dead = \"not\" ]
17
1
11

SWITCH
840
351
958
384
saveInFile?
saveInFile?
1
1
-1000

@#$#@#$#@
## WHAT IS IT?

The model consists of the analysis of a COVID-19 performance scenario between young and old

## HOW IT WORKS

In the model will be placed several people, of different ages and with the use of a mask or not. In this way, the researcher will analyze the behavior of the virus in this environment, analyzing data such as rate of cured and deaths

## HOW TO USE IT

The observer can choose between several characteristics for the agents, such as age, whether to use a mask, sex, whether he is in isolation, whether he is infected, the number of agents that will make up the world. From the union of these characteristics, a world will be created and when starting the simulation the agents will interact with each other and the result of this simulation will be plotted on the graph and in the data outputs

## THINGS TO NOTICE

The researcher must observe all the data that are shown on the screen, in addition to analyzing the rate of cured, deaths and virus behavior in that particular location, analyzing the likelihood of infection by people with masks and comparing with those who do not wear a mask.

## THINGS TO TRY

What is the best scenario? what happens when everyone is wearing a mask? and all without a mask? and when they are mixed, with a mask and without a mask? Who is more likely to die, elderly or young? 

## EXTENDING THE MODEL

More realistic data can be entered on the transmission of COVID-19 and the recovery of contaminants

## NETLOGO FEATURES

Input and output resources from the net logo were used so that the observer could manipulate all the characteristics of the agents (turtles) and thus be able to analyze all the data that are generated from graphics and text boxes. Netlogo's own graphic resources were also used to model and design the agents

## RELATED MODELS

See other models in the Biology section of the Model Library, such as "viruses"

## CREDITS AND REFERENCES

Developed by Rafael dos Santos Luna da Silva and William da Silva Santos Pinheiro, 2020

Coordinated and supervised by Dr. Márcio Renê Brandão Soussa
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

acorn
false
0
Polygon -7500403 true true 146 297 120 285 105 270 75 225 60 180 60 150 75 105 225 105 240 150 240 180 225 225 195 270 180 285 155 297
Polygon -6459832 true false 121 15 136 58 94 53 68 65 46 90 46 105 75 115 234 117 256 105 256 90 239 68 209 57 157 59 136 8
Circle -16777216 false false 223 95 18
Circle -16777216 false false 219 77 18
Circle -16777216 false false 205 88 18
Line -16777216 false 214 68 223 71
Line -16777216 false 223 72 225 78
Line -16777216 false 212 88 207 82
Line -16777216 false 206 82 195 82
Line -16777216 false 197 114 201 107
Line -16777216 false 201 106 193 97
Line -16777216 false 198 66 189 60
Line -16777216 false 176 87 180 80
Line -16777216 false 157 105 161 98
Line -16777216 false 158 65 150 56
Line -16777216 false 180 79 172 70
Line -16777216 false 193 73 197 66
Line -16777216 false 237 82 252 84
Line -16777216 false 249 86 253 97
Line -16777216 false 240 104 252 96

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person female
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105
Polygon -2064490 true false 105 180 120 180 75 255 150 240 225 255 180 180 120 180
Rectangle -2064490 true false 60 45 75 45
Circle -16777216 true false 75 75 0
Polygon -1184463 true false 210 75 150 30 90 75 120 15 150 0 180 15 195 30

person female protect
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105
Polygon -2064490 true false 105 180 120 180 75 255 150 240 225 255 180 180 120 180
Rectangle -2064490 true false 60 45 75 45
Circle -16777216 true false 75 75 0
Polygon -1184463 true false 210 75 150 30 90 75 120 15 150 0 180 15 195 30
Polygon -1 true false 105 60 195 60 180 75 120 75 105 60

person man
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105
Rectangle -13345367 true false 105 45 210 45
Rectangle -13345367 true false 75 30 195 45
Polygon -13345367 true false 120 30 195 30 165 0 105 15 105 30
Polygon -13345367 true false 120 195 120 195 180 195 210 270 165 285 150 240 135 285 135 285 90 270 120 195

person man protect
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105
Rectangle -13345367 true false 105 45 210 45
Rectangle -13345367 true false 75 30 195 45
Polygon -13345367 true false 120 30 195 30 165 0 105 15 105 30
Polygon -13345367 true false 120 195 120 195 180 195 210 270 165 285 150 240 135 285 135 285 90 270 120 195
Polygon -1 true false 105 60 195 60 180 75 120 75

person old
false
0
Circle -7500403 true true 95 5 80
Polygon -7500403 true true 90 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 165 90
Rectangle -7500403 true true 112 79 157 94
Polygon -7500403 true true 165 90 210 150 195 180 135 105
Polygon -7500403 true true 90 90 45 150 60 180 120 105
Rectangle -6459832 true false 45 165 60 300
Rectangle -6459832 true false 75 30 75 30
Polygon -6459832 true false 60 45 135 0 180 15 180 45 60 45

person old female
false
0
Circle -7500403 true true 95 5 80
Polygon -7500403 true true 90 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 165 90
Rectangle -7500403 true true 112 79 157 94
Polygon -7500403 true true 165 90 210 150 195 180 135 105
Polygon -7500403 true true 90 90 45 150 60 180 120 105
Rectangle -6459832 true false 45 165 60 300
Polygon -2064490 true false 120 195 120 195 90 270 150 240 225 255 180 180 120 195
Rectangle -2064490 true false 60 45 75 45
Rectangle -2064490 true false 75 30 195 45
Polygon -2064490 true false 90 30 90 30 180 30 150 0 105 0 90 30

person old female protect
false
0
Circle -7500403 true true 95 5 80
Polygon -7500403 true true 90 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 165 90
Rectangle -7500403 true true 112 79 157 94
Polygon -7500403 true true 165 90 210 150 195 180 135 105
Polygon -7500403 true true 90 90 45 150 60 180 120 105
Rectangle -6459832 true false 45 165 60 300
Polygon -2064490 true false 120 195 120 195 90 270 150 240 225 255 180 180 120 195
Rectangle -2064490 true false 60 45 75 45
Rectangle -2064490 true false 75 30 195 45
Polygon -2064490 true false 90 30 90 30 180 30 150 0 105 0 90 30
Polygon -1 true false 90 60 180 60 180 60 165 75 105 75 90 60

person old protect
false
0
Circle -7500403 true true 95 5 80
Polygon -7500403 true true 90 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 165 90
Rectangle -7500403 true true 112 79 157 94
Polygon -7500403 true true 165 90 210 150 195 180 135 105
Polygon -7500403 true true 90 90 45 150 60 180 120 105
Rectangle -6459832 true false 45 165 60 300
Rectangle -6459832 true false 75 30 75 30
Polygon -6459832 true false 60 45 135 0 180 15 180 45 60 45
Polygon -1 true false 90 60 180 60 165 75 105 75 90 60

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

rip
true
0
Polygon -6459832 true false 105 285 195 285 255 90 195 45 105 45 60 105 105 285 120 270 105 285 195 285 195 285 195 285
Polygon -1 true false 135 180 165 180 165 120 225 120 225 105 165 105 165 75 135 75 135 105 75 105 75 120 135 120 135 180 135 180 135 180 165 180 165 180 165 180 165 180 165 180 165 180 135 180 135 180 135 180 135 180
Line -1 false 180 270 240 90
Line -1 false 240 90 195 60
Line -1 false 195 60 105 60
Line -1 false 105 60 75 105
Line -1 false 75 105 120 270
Line -1 false 120 270 180 270

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
