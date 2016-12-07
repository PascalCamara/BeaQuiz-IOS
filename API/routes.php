<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the controller to call when that URI is requested.
|
*/

use Illuminate\Http\Request;
use \Illuminate\Support\Facades\DB;


Route::get('/API/hello/{username}', function ($username) {
    return "Hello $username";
});


// games
Route::get('/API/games', function () {
    return $games = \Illuminate\Support\Facades\DB::table("bq_games")->get();
});





/**
 *  LOGIN SCREEN
 */
// Exist -> O | 1
Route::get('/API/player/exist/{pseudo}', function ($pseudo) {
    
    if (DB::table("bq_players")->where("pseudo",$pseudo)->get()) {
        return 1;
    } else {
        return 0;
    };
});
// Create -> 0 | token
Route::post('/API/player/create/', function(Request $request) {
    $pseudo = $request->pseudo;

    if (empty($pseudo)) return false;

    $date = new DateTime();
    $date = $date->format('Y/m/d-H:i:s');
    $token = $date .'.'. md5($date + $pseudo);

    $insert = DB::insert("insert into bq_players (pseudo, token) values (?, ?)", [$pseudo, $token]);
    
    if ($insert) {
        return $token;

    } else {
        return 0;
    }
});

function tokenIsValid ($token) {
    
    $testDB = DB::table('bq_players')->where("token", $token)->first();
    if ($testDB == null) {
        return false;
    } else {
        return true;
    }
    
}

/**
 * CONFIG NEW GAME
 */
//Create game -> id, invit_code, name
Route::post('/API/game/create/', function(Request $request) {

    if (!tokenIsValid($request->token)) return false;

    $name = $request->name;
    $invit_code = rand(1000,4000);

    $insert = DB::table("bq_games")->insertGetId([
        "name" => $name,
        "code" => $invit_code
    ]);

    DB::table("bq_players")
        ->where("token", $request->token)
        ->update(["game_id" => "".$insert]);
        
    return json_encode([
        "id" => "".$insert,
        "name" => $name,
        "invit_code" => "".$invit_code
    ]);
});

/**
* JOIN GAME
*/
// Select game -> invit_code, id
Route::post('/API/game/select/', function(Request $request) {
    if (!tokenIsValid($request->token)) return false;

    $invit_code = $request->invit_code;

    $game = DB::table("bq_games")->where([ 
        ["code", "=", $invit_code],
        ["state", "=", "0"]
    ])->first();

    
    $insert = DB::table("bq_players")
        ->where("token", $request->token)
        ->update(["game_id" => $game->id]);

    return json_encode([
        "id" => $game->id,
        "name" => $game->name
    ]);
});

/**
* WAIT SCREEN
*/
// start game
Route::post('/API/game/start/', function(Request $request) {
    if (!tokenIsValid($request->token)) return false;
    
    $game_id = $request->game_id;
    
    // get all players
    $players_game = DB::table('bq_players')
                    ->where("game_id", $game_id)->get();

    // dispatch teams
    if ($players_game && (count($players_game) >= 2)) {
        $composed_team = array(
            0 => array(),
            1 => array()
        );   

        //create team about game
        
        foreach ($players_game as $key => $player) {
            $rand_team = $key % 2;
            array_push($composed_team[$rand_team], $player);
        }
        
        // une fois equipe inséré -> mettre value game_id a null dans table player
        
        //var_dump($composed_team);
        
        $team1_id = DB::table("bq_teams")->where([ 
            ["bq_games_id", "=", $game_id], 
            ["team_order" , "=", 0]
            ])->first();
       
        if ($team1_id == null) {
            $team1_id = DB::table("bq_teams")->insertGetId([
                "team_order" => 0,
                "bq_games_id" => $game_id
            ]);
        } else {
            $team1_id = $team1_id->id;
        }

       
        
        $team2_id = DB::table("bq_teams")->where([ 
            ["bq_games_id", "=", $game_id], 
            ["team_order" , "=", 1]
            ])->first();
       
        if ($team2_id == null) {
            $team2_id = DB::table("bq_teams")->insertGetId([
                "team_order" => 1,
                "bq_games_id" => $game_id
            ]);
        } else {
            $team2_id = $team2_id->id;
        }


        // insert in individual player score  team 1
        foreach($composed_team[0] as $key => $playerTeam) {
           // var_dump($playerTeam);
            // verifie if exist insertion ... 
            $indTeamScoreExist = DB::table("bq_individual_scores")->where([
                ["bq_teams_id", "=", $team1_id],
                ["bq_players_id", "=", $playerTeam->id],
                ["bq_games_id", "=", $game_id]
                ])->first();

                // insert
            if ($indTeamScoreExist == null) {
                DB::table("bq_individual_scores")->insertGetId([
                    "bq_teams_id" => $team1_id,
                    "bq_players_id" => $playerTeam->id,
                    "bq_games_id" => $game_id
                ]);
            }
        }

        // team 2
        foreach($composed_team[1] as $key => $playerTeam) {
            //var_dump($playerTeam);
            // verifie if exist insertion ... 
            $indTeamScoreExist1 = DB::table("bq_individual_scores")->where([
                ["bq_teams_id", "=", $team2_id],
                ["bq_players_id", "=", $playerTeam->id],
                ["bq_games_id", "=", $game_id]
                ])->first();

                // insert
            if ($indTeamScoreExist1 == null) {
                DB::table("bq_individual_scores")->insertGetId([
                    "bq_teams_id" => $team2_id,
                    "bq_players_id" => $playerTeam->id,
                    "bq_games_id" => $game_id
                ]);
            }
        }

        // get team_id of payer
       /* SELECT * FROM bq_players
INNER JOIN bq_individual_scores
    ON bq_players.id = bq_individual_scores.bq_players_id
WHERE bq_players.token = TOKEN
    AND bq_individual_scores.bq_games_id = GAME_ID*/

    $userTeam = DB::table("bq_players")
        ->join("bq_individual_scores", "bq_players.id" , "=", "bq_individual_scores.bq_players_id" )
        ->where([
            ["bq_players.token", "=", $request->token],
            ["bq_individual_scores.bq_games_id", "=" , $game_id]
        ])->first();
    
         //var_dump($userTeam);
        $date = date("Y-m-d H:i:s");
        DB::table("bq_games")
            ->where("id", "=", $game_id)
            ->update([
                "state" => 1, 
                "started_at" => $date
        ]);
         
        return ($userTeam->bq_teams_id);
    
    
    } else {
        return 0; 
    }
    
});

// game is started ?
Route::get('/API/game/is_started/{game_id}' , function ($game_id) {

    $select = DB::table("bq_games")->where("id", $game_id)->first();

    if ($select) {
        return $select->state;
    } else {
        return 0;
    }
});

// delete game

/**
* GAME SCREEN
*/

// get beacons/id_game

// get quiz
Route::get("API/quiz", function() {
    $questions = DB::select(DB::raw("SELECT * FROM bq_questions ORDER BY RAND() LIMIT 10"));
    if ($questions) {
        foreach ($questions as $key => $question) {
            $questions[$key]->responses = DB::table("bq_responses")->where("bq_responses.id_question", $question->id)->get();
        }
        return $questions;
    } else {
        return false;
    }
});

// post result quiz
Route::post("API/quiz/submit", function(Request $request) {
    if (!tokenIsValid($request->token)) return false;

    // get id player
    $player = DB::table("bq_players")->where("token", $request->token)->first();

    if($player) {
        // calculing score
        $score = ( $request->score * 100 );
    
        // update individuals score
        return $insert = DB::table("bq_individual_scores")->where([
            ["bq_games_id", "=", $request->game_id],
            ["bq_players_id", "=", $player->id]
        ])->increment("score", $score);
    }
    

});

// post result quiz flash

// get check game date and return second remain
Route::get('API/game/check_time/{game_id}', function($game_id) {

   
    $select = DB::table("bq_games")->where("id", $game_id)->first();

    if ($select) {
        $date1 = new DateTime($select->started_at);
        $date2 = new DateTime();
        
        $diffInSeconds = ($date1->getTimestamp() + $select->duration) - $date2->getTimestamp();

        return $diffInSeconds <= 0? 0 : $diffInSeconds;
    }
    return false;
});

/**
*  GAME RESULT && GAME just before start 
*  to see teams
*/

// POST result/game_id
Route::post('API/game/result/', function(Request $request) {
    if (!tokenIsValid($request->token)) return false;
    //echo "done";

    /*
    SELECT 
    bq_individual_scores.*, 
    bq_players.pseudo, 
    bq_teams.team_order, 
    bq_teams.bonus_score 
    
    FROM bq_players 
    
    INNER JOIN bq_individual_scores 
        ON bq_players.id = bq_individual_scores.bq_players_id 
    
    INNER JOIN bq_teams 
        ON bq_teams.id = bq_individual_scores.bq_teams_id 
        
    WHERE bq_individual_scores.bq_games_id = 7
    */

    return $array = DB::select( DB::raw("SELECT 
            bq_individual_scores.*, 
            bq_players.pseudo, 
            bq_teams.team_order, 
            bq_teams.bonus_score 
    
            FROM bq_players 
            
            INNER JOIN bq_individual_scores 
                ON bq_players.id = bq_individual_scores.bq_players_id 
            
            INNER JOIN bq_teams 
                ON bq_teams.id = bq_individual_scores.bq_teams_id 
                
            WHERE bq_individual_scores.bq_games_id = :game_id"), array(
        'game_id' => $request->game_id
    ));
        
});

