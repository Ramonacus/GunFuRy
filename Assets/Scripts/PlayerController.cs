using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    public float speed = 5f;
    public Vector2 direction;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        float verticalInput = Input.GetAxis("Vertical");
        float horizontalInput = Input.GetAxis("Horizontal");
        direction = new Vector2(horizontalInput, verticalInput);
        direction = Vector2.ClampMagnitude(direction, 1);
        transform.Translate(direction * speed * Time.deltaTime);
    }
}
