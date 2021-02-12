using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ZombiMovement : MonoBehaviour
{
    private GameObject player;

    Rigidbody2D enemyRb;
    public float speed = 2f;
    public float attackRange = 1f;

    void Awake()
    {
        player = GameObject.Find("Player");
        enemyRb = GetComponent<Rigidbody2D>();
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        Vector2 directionToPlayer = player.transform.position - transform.position;
        if (directionToPlayer.magnitude > attackRange)
        {
            directionToPlayer = Vector2.ClampMagnitude(directionToPlayer, 1);
            enemyRb.MovePosition(GetPosition2D() + directionToPlayer * speed * Time.deltaTime);
        }
        else
        {

        }

        // TODO replace with actual animations for moving left
        if (directionToPlayer.x < 0)
        {
            transform.rotation = new Quaternion(0, 180, 0, 0);
        }
        else
        {
            transform.rotation = new Quaternion(0, 0, 0, 0);
        }
    }

    Vector2 GetPosition2D()
    {
        return new Vector2(transform.position.x, transform.position.y);
    }
}