using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ZombiMovement : MonoBehaviour
{
    public float speed = 2f;
    private GameObject player;

    void Awake()
    {
        player = GameObject.Find("Player");
    }

    // Update is called once per frame
    void Update()
    {
        Vector2 direction = player.transform.position - transform.position;
        direction = Vector2.ClampMagnitude(direction, 1);
        transform.Translate(direction * speed * Time.deltaTime);
    }
}