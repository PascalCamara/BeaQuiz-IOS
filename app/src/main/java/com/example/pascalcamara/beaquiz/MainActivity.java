package com.example.pascalcamara.beaquiz;

import android.content.Intent;
import android.support.v4.content.res.ResourcesCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;

import java.io.File;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //change color of status bar
        Window window = getWindow();
        window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
        window.setStatusBarColor( ResourcesCompat.getColor(getResources(), R.color.colorAccent, null));

        // verrify if token exist
        File internal = getFilesDir();
        final File f = new File(internal, "token");

        if (f.exists()) {
            // send http request to verify and get player info

        } else {
            // switch to create login
            Intent i = new Intent( this , CreatePseudo.class);
            startActivity(i);
        }

        // join game on click
        Button joinGameBtn = (Button) findViewById(R.id.joinGameBtn);
        joinGameBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // switch to view join game
            }
        });

        // create game on click
        Button createGameBtn = (Button) findViewById(R.id.createGameBtn);
        createGameBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                //switch to view create game
            }

        });


    }
}
